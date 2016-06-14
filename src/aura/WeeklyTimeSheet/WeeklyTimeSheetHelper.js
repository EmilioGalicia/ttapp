({
	setWeekLabel : function(component) {
		var action = component.get("c.currentWeek");

		action.setCallback(this, function(response){
			var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.weekLabel", response.getReturnValue());
            }
		});
		$A.enqueueAction(action);
	},
	setTotalHours : function (component) {
		var action = component.get("c.getTotalHoursWeek");

		action.setCallback(this, function(response){
			var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.totalHours", response.getReturnValue());
            }
		});
		$A.enqueueAction(action);
	},
	requestApprovalLock : function (component) {
		var action = component.get("c.lockRecords");

		action.setCallback(this, function(response){
			var state = response.getState();
            if (state === "SUCCESS") {
            	    
            }
		});
		$A.enqueueAction(action);
	}
})