public with sharing class TimerUtil {
	
	/**
	*	@summary retrieves a list of time entries based on a projectID
	*	@param projectID is the Salesforce record ID of a Project record
	*/
	@AuraEnabled
	public static List<timetrackerapp__Time_Entry__c> getTimeEntriesByProjectID (Id projectID) {
		
		List<timetrackerapp__Time_Entry__c> entryLst = [SELECT timetrackerapp__Hours__c, 
																timetrackerapp__Project_ID__r.Name,
																timetrackerapp__Task_ID__r.Name,
																timetrackerapp__Timer_Started_At__c
																FROM timetrackerapp__Time_Entry__c
																WHERE timetrackerapp__Project_ID__c =: projectID
																ORDER BY CreatedDate DESC
																LIMIT 20];
		return entryLst != null ? entryLst : new List<timetrackerapp__Time_Entry__c>();
	}

	/**
	*	@summary finds all time entries depending on the record passed as param
	*	@param objectID is the Salesforce record ID of a Project or Time Entry record
	*/
	@AuraEnabled
	public static List<timetrackerapp__Time_Entry__c> findEntries (Id objectID) {
		Id lookupId;
		if (objectID.getSobjectType() == Schema.timetrackerapp__Project__c.SObjectType) {
			lookupId = objectID;
		} else if (objectID.getSobjectType() == Schema.timetrackerapp__Time_Entry__c.SObjectType) {
			lookupId = [SELECT timetrackerapp__Project_ID__c FROM timetrackerapp__Time_Entry__c WHERE Id =: objectID].timetrackerapp__Project_ID__c;
		}

		return lookupId != null ? getTimeEntriesByProjectID(lookupId) : new List<timetrackerapp__Time_Entry__c>();
	}

	/**
	*	@summary Updates a Time Entry record
	*	@param start if the timer should start
	*	@param timeEntryId is the time entry record ID
	*	@return true if the entry is running, otherwise false
	*/
	@AuraEnabled
	public static Boolean updateEntry (Boolean start, Id timeEntryId) {
		
		timetrackerapp__Time_Entry__c te = [SELECT Id, timetrackerapp__Timer_Started_At__c FROM timetrackerapp__Time_Entry__c WHERE Id =: timeEntryId];
		
		if (te != null) {

			te.timetrackerapp__Timer_Started_At__c = start ? Datetime.now() : null;
			Database.SaveResult sr = Database.update(te);

			//if is running
			return (start && sr.isSuccess()) || (!start && !sr.isSuccess()) ? true : false;
		}
		return false;
	}

	/**
	*	@summary: clears the timer of the time entries provided
	*/
	public static void clearEntries (Set<Id> projectIds) {
		List<timetrackerapp__Time_Entry__c> entries = new List<timetrackerapp__Time_Entry__c>();
		for (timetrackerapp__Time_Entry__c te : [SELECT timetrackerapp__Timer_Started_At__c,
												timetrackerapp__Hours__c,
												timetrackerapp__ElapsedTimerTime__c
												FROM timetrackerapp__Time_Entry__c 
												WHERE timetrackerapp__Project_ID__c IN: projectIds
												AND timetrackerapp__Timer_Started_At__c != null]) {
			te.timetrackerapp__Hours__c = te.timetrackerapp__Hours__c == null ? 0 : te.timetrackerapp__Hours__c;
			te.timetrackerapp__Hours__c = calculateHours(te.timetrackerapp__ElapsedTimerTime__c, te.timetrackerapp__Hours__c);
			te.timetrackerapp__Timer_Started_At__c = null;
			entries.add(te);
		}
		Database.SaveResult[] sr = Database.update(entries);
	}

	public static Map<Id, Decimal> stopAndCalculateMap (Set<Id> entries) {
		Map<Id, Decimal> stopMap = new Map<Id, Decimal>();
		for (timetrackerapp__Time_Entry__c te : [SELECT timetrackerapp__Hours__c, timetrackerapp__ElapsedTimerTime__c 
																		FROM timetrackerapp__Time_Entry__c WHERE Id IN: entries]) {
			stopMap.put(te.Id, calculateHours(te.timetrackerapp__ElapsedTimerTime__c, te.timetrackerapp__Hours__c == null ? 0 : te.timetrackerapp__Hours__c));

		}
		return stopMap;
	}	

	/**
	*	@summary: calculates the hours tracked by the timer in Decimal hours
	*/
	public static Decimal calculateHours (Decimal elapsedMinutes, Decimal currentHours) {

		Long mod;
		Decimal hours = 0;
		Decimal minutes = 0;
		Decimal seconds = 0;

		if (elapsedMinutes >= 60) {
			hours = (elapsedMinutes/60);
			mod = Math.mod( (Long) elapsedMinutes, 60 );
		}

		if (mod != null) {
			minutes = (mod / 60.00);
		} else if (elapsedMinutes >= 1) {
			minutes = (elapsedMinutes / 60);
			mod = (Long)(elapsedMinutes / 60);
		}

		if (mod != null) {
			seconds = ((mod * 60.00) / 3600);
		} else {
			seconds = (elapsedMinutes * 60) / 3600;
		}

		return currentHours + (hours + minutes + seconds);
	}

}