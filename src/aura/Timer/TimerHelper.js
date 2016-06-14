({
	setTimeEntry : function (component) {
		
	},
	setIsRunning : function (component) {

		if (component.get("v.startedAt")) {
			component.set("v.isRunning", true);
		}
	},
	updateEntry : function (component, start) {
		var action = component.get('c.updateEntry');
		
		action.setParams({
			"start" : start,
			"timeEntryId" : component.get("v.timeEntryId")
		});

		action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isRunning", response.getReturnValue());
                $A.get('e.force:refreshView').fire();
            }
        });
	 	$A.enqueueAction(action);
	}
})