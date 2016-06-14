({
	createRecord : function (component, event, helper) {
    	var createRecordEvent = $A.get("e.force:createRecord");
    	createRecordEvent.setParams({
        	"entityApiName": "timetrackerapp__Time_Entry__c"
    	});
    	createRecordEvent.fire();
	},
	doInit : function (component, event, helper) {
		helper.getEntries(component);
	}
})