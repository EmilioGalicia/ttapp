@isTest
private class Test_WeeklyTimeSheetUtil
{	
	@testSetup static void methodName() {
		
		TestUtil.insertProjects(TestUtil.insertAccounts(10));
		TestUtil.insertTasks(10);
		
		List<Account> acctLst = [SELECT Id FROM Account LIMIT 10];
		List<timetrackerapp__Task__c> taskLst = [SELECT Id FROM timetrackerapp__Task__c LIMIT 10];
		List<timetrackerapp__Project__c> projLst = [SELECT Id FROM timetrackerapp__Project__c LIMIT 10];

		TestUtil.insertTimeEntries(projLst.get(0).Id, taskLst.get(0).Id, acctLst.get(0).Id, 10, 10);
	}

	@isTest
	static void test_getTotalHoursWeek() {
		
		//based on 10 records inserted with 10 hours each	
		Test.startTest();
		System.assertEquals(WeeklyTimeSheetUtil.getTotalHoursWeek(), 100);
		Test.stopTest();

	}

	@isTest
	static void test_currentWeekLabel() {
		// Given
		Datetime now = Datetime.now();
		Date myDate = Date.today();
		Date weekStart = myDate.toStartofWeek();

		//check if it's Sunday night
		if (Date.today().isSameDay(weekStart+7) && now.hour() >= 20)  {
			weekStart = weekStart + 8;
		}

		String result = '';
		Integer starts = weekStart.day()+1;
		Integer ends = weekStart.day()+7;
		result = starts + '-' + ends + ' ' + WeeklyTimeSheetUtil.getMonthsMap().get( weekStart.month()) + ' ' + weekStart.year();

		Test.startTest();
		System.assertEquals(WeeklyTimeSheetUtil.currentWeek(), result);
		Test.stopTest();


	}
}