public with sharing class TimeEntryTriggerHandler extends TriggerHandler {

	/* context overrides */

	protected override void beforeUpdate () {
		System.debug('beforeUpdate');
		setTimers();
	}

	/* private methods */

	/**
	*	@summary: sets the timer for the latest entry sent and clears the previous one
	*/
	private void setTimers () {

		Set<Id> projectIds = new Set<Id>();
		Set<Id> entriesToQuery = new Set<Id>();

		Map<Id, timetrackerapp__Time_Entry__c> oldMap = new Map<Id, timetrackerapp__Time_Entry__c>((List<timetrackerapp__Time_Entry__c>) Trigger.old);

		for (timetrackerapp__Time_Entry__c te : (List<timetrackerapp__Time_Entry__c>)Trigger.newMap.values()) {
			System.debug('te.timetrackerapp__Timer_Started_At__c');

			//started the timer
			if (oldMap.get(te.Id).timetrackerapp__Timer_Started_At__c == null && te.timetrackerapp__Timer_Started_At__c != null) {

				projectIds.add(te.timetrackerapp__Project_ID__c);
			
			} else if (oldMap.get(te.Id).timetrackerapp__Timer_Started_At__c != null && te.timetrackerapp__Timer_Started_At__c == null) {
				entriesToQuery.add(te.Id);				
			}

		}
		
		Map<Id, Decimal> calculatedMap = TimerUtil.stopAndCalculateMap(entriesToQuery);
		
		for (timetrackerapp__Time_Entry__c te : (List<timetrackerapp__Time_Entry__c>)Trigger.new) {
			if (calculatedMap.containsKey(te.Id)) {
				te.timetrackerapp__Hours__c = calculatedMap.get(te.Id);
			}
		}

		TimerUtil.clearEntries(projectIds);
	}
}