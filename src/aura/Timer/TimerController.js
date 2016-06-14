({
	doInit : function (component, event, helper) {
		helper.setTimeEntry(component);
		helper.setIsRunning(component);
	},
	startTimer : function (component, event, helper) {
		helper.updateEntry(component, true);
	},
	stopTimer : function (component, event, helper) {
		helper.updateEntry(component, false);	
	}
})