trigger TimerEntryTrigger on timetrackerapp__Time_Entry__c (
	before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	new TimeEntryTriggerHandler().run();
}