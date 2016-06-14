@isTest
public class TestUtil {
	
	public static List<Account> insertAccounts (Integer total) {
		List<Account> sobjLst = new List<Account>();

		for (integer x = 0; x < total; x++) {
			Account acct = new Account();
			acct.Name = 'acct-' + x;
			sobjLst.add(acct);
		}

		insert sobjLst;
		return sobjLst;
	}
	
	public static List<timetrackerapp__Project__c> insertProjects (List<Account> clients) {
		List<timetrackerapp__Project__c> sobjLst = new List<timetrackerapp__Project__c>();
		for (Account a : clients) {
			timetrackerapp__Project__c project =  new timetrackerapp__Project__c();
			project.timetrackerapp__Client__c = a.Id;
			project.Name = 'client-' + a.Id;
			sobjLst.add(project);
		}

		insert sobjLst;
		return sobjLst;
	}

	public static List<timetrackerapp__Task__c> insertTasks (Integer total) {
		List<timetrackerapp__Task__c> sobjLst = new List<timetrackerapp__Task__c>();

		for (integer x = 0; x < total; x++) {
			timetrackerapp__Task__c task = new timetrackerapp__Task__c();
			task.Name = 'task-' + x;
			sobjLst.add(task);
		}

		insert sobjLst;
		return sobjLst;
	}

	public static List<timetrackerapp__Time_Entry__c> insertTimeEntries (Id projectID, Id taskID, Id clientID, Decimal hours, Integer total) {
		List<timetrackerapp__Time_Entry__c> sobjLst = new List<timetrackerapp__Time_Entry__c>();

		for (integer x = 0; x < total; x++) {
			timetrackerapp__Time_Entry__c te = new timetrackerapp__Time_Entry__c();
			te.timetrackerapp__Client_ID__c = clientID;
			te.timetrackerapp__Task_ID__c = taskID;
			te.timetrackerapp__Project_ID__c = projectID;
			te.timetrackerapp__Spent_At__c = Date.today();
			te.timetrackerapp__Hours__c = hours;
			sobjLst.add(te);
		}

		insert sobjLst;
		return sobjLst;
	}
}