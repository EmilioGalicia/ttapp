public with sharing class WeeklyTimeSheetUtil {
	
	/**
	* @summary Date when the week started
	*/
	private static Date weekStart () {
		Datetime now = Datetime.now();
		Date myDate = Date.today();
		Date weekStart = myDate.toStartofWeek();

		//check if it's Sunday night
		if (Date.today().isSameDay(weekStart+7) && now.hour() >= 20)  {
			weekStart = weekStart + 8;
		}

		return weekStart;
	}

	/**
	* @return the Label of the current week
	*/
	@AuraEnabled
	public static String currentWeek () {
		String result = '';
		Integer starts = weekStart().day()+1;
		Integer ends = weekStart().day()+7;
		result = starts + '-' + ends + ' ' + getMonthsMap().get( weekStart().month()) + ' ' + weekStart().year();
		return result;
	}

	/**
	* @return the time entries of the current week
	*/
	@AuraEnabled
	public static Map<Date, List<timetrackerapp__Time_Entry__c>> getCurrentWeekEntries () {
		Map<Date, List<timetrackerapp__Time_Entry__c>> resultMap = new Map<Date, List<timetrackerapp__Time_Entry__c>>();
		for (timetrackerapp__Time_Entry__c te : [SELECT timetrackerapp__Hours__c, 
												timetrackerapp__Task_ID__r.Name,
												timetrackerapp__Project_ID__r.Name,
												timetrackerapp__Spent_At__c
												FROM timetrackerapp__Time_Entry__c
												WHERE timetrackerapp__Spent_At__c >=: weekStart()+1
												AND timetrackerapp__Spent_At__c <=: weekStart()+7
												ORDER BY timetrackerapp__Spent_At__c ]) {
			if (resultMap.containsKey(te.timetrackerapp__Spent_At__c)) {
				resultMap.get(te.timetrackerapp__Spent_At__c).add(te);
			} else {				
				resultMap.put(te.timetrackerapp__Spent_At__c, new List<timetrackerapp__Time_Entry__c>{te});
			}
			
		}
		return resultMap;
	}

	/**
	* @return total hours of the current week
	*/
	@AuraEnabled
	public static Decimal getTotalHoursWeek () {
		Decimal result = 0;
		for (Date key : getCurrentWeekEntries().keySet()) {
			for (timetrackerapp__Time_Entry__c te : getCurrentWeekEntries().get(key)) {
				result += te.timetrackerapp__Hours__c;
			}
		}
		return result;
	}

	/*
	* @return approves a time sheet and locks all records
	* not being used at this time due to execution errors
	
	@AuraEnabled
	public static Boolean lockRecords () {
		Boolean result = true;
		List<timetrackerapp__Time_Entry__c> approveLst = new List<timetrackerapp__Time_Entry__c>();
		for (Date key : getCurrentWeekEntries().keySet()) {
			for (timetrackerapp__Time_Entry__c te : getCurrentWeekEntries().get(key)) {
				approveLst.add(te);
			}
		}
		System.debug('approveLst ' + approveLst);
		Approval.LockResult[] lrList = Approval.lock(approveLst);

		for(Approval.LockResult lr : lrList) {
		    if (!lr.isSuccess()) {
		        result = false;
		        break;
		    }
		}
		return result;
	}

	*/

	/**
	*	@param day is the number of the day of the week 1 - Monday , 2 = Tuesday...
	* 	@return the time entries of the current week
	*/
	@AuraEnabled
	public static List<timetrackerapp__Time_Entry__c> getCurrentWeekEntriesByDay (Double day) {
	
		Date lookupDate = weekStart();
		lookupDate = lookupDate.addDays(Integer.valueOf(day)+1);
		
		List<timetrackerapp__Time_Entry__c> resultLst = new List<timetrackerapp__Time_Entry__c>();
		for (timetrackerapp__Time_Entry__c te : [SELECT timetrackerapp__Hours__c, 
												timetrackerapp__Project_ID__r.Name,
												timetrackerapp__Task_ID__r.Name,
												timetrackerapp__Spent_At__c
												FROM timetrackerapp__Time_Entry__c
												WHERE timetrackerapp__Spent_At__c =: lookupDate
												ORDER BY timetrackerapp__Spent_At__c ]) {
			resultLst.add(te);
			
		}
		return resultLst;
	}

	/**
	* @return map of the months
	*/
	public static Map<Integer, String> getMonthsMap () {
		Map<Integer, String> resultMap = new Map<Integer, String>();
		resultMap.put(1, 'Jan');
		resultMap.put(2, 'Feb');
		resultMap.put(3, 'Mar');
		resultMap.put(4, 'Apr');
		resultMap.put(5, 'May');
		resultMap.put(6, 'Jun');
		resultMap.put(7, 'Jul');
		resultMap.put(8, 'Aug');
		resultMap.put(9, 'Sep');
		resultMap.put(10, 'Oct');
		resultMap.put(11, 'Nov');
		resultMap.put(12, 'Dec');
		return resultMap;
	}



}