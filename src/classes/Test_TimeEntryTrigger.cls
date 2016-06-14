@isTest
private class Test_TimeEntryTrigger
{
	@testSetup static void methodName() {
		
		TestUtil.insertProjects(TestUtil.insertAccounts(10));
		TestUtil.insertTasks(10);
		
	}


	@isTest
	static void activateNewTimer() {	
		List<Account> acctLst = [SELECT Id FROM Account LIMIT 10];
		List<timetrackerapp__Task__c> taskLst = [SELECT Id FROM timetrackerapp__Task__c LIMIT 10];
		List<timetrackerapp__Project__c> projLst = [SELECT Id FROM timetrackerapp__Project__c LIMIT 10];

		// Given
		timetrackerapp__Time_Entry__c te = new timetrackerapp__Time_Entry__c();
		te.timetrackerapp__Client_ID__c = acctLst.get(0).Id;
		te.timetrackerapp__Task_ID__c = taskLst.get(0).Id;
		te.timetrackerapp__Project_ID__c = projLst.get(0).Id;
		insert te;

		timetrackerapp__Time_Entry__c teActive = new timetrackerapp__Time_Entry__c();
		teActive.timetrackerapp__Client_ID__c = acctLst.get(0).Id;
		teActive.timetrackerapp__Task_ID__c = taskLst.get(0).Id;
		teActive.timetrackerapp__Project_ID__c = projLst.get(0).Id;
		teActive.timetrackerapp__Timer_Started_At__c = Datetime.now();
		insert teActive;
		
		//make assertions before
		System.assertNotEquals(teActive.timetrackerapp__Timer_Started_At__c, null);

		// insert a time entry
		Test.startTest();
		te.timetrackerapp__Timer_Started_At__c = Datetime.now();
		update te;
		Test.stopTest();

		// Then
		timetrackerapp__Time_Entry__c afterTe = [SELECT timetrackerapp__Timer_Started_At__c 
												FROM timetrackerapp__Time_Entry__c 
												WHERE Id=: te.Id];
		

		timetrackerapp__Time_Entry__c afterTeActive = [SELECT timetrackerapp__Timer_Started_At__c 
												FROM timetrackerapp__Time_Entry__c 
												WHERE Id=: teActive.Id];

		//new timer should be active
		System.assertNotEquals(afterTe.timetrackerapp__Timer_Started_At__c, null);
		
		//verify the timer was deactivated
		System.assertEquals(afterTeActive.timetrackerapp__Timer_Started_At__c, null);

		
	}
}