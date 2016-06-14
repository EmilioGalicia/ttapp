({
	doInit : function(component, event, helper) {
		helper.setWeekLabel(component);
		helper.setTotalHours(component);
	},
	approveTimeSheet : function (component, event, helper) {
		helper.requestApprovalLock(component);
	}
})