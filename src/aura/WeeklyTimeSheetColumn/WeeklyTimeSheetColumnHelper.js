({
	setColumnValues : function (component) {
		var action = component.get("c.getCurrentWeekEntriesByDay");
		
		action.setParams({
			"day" : component.get("v.dayNumber")
		});
		
		action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.columnItems", response.getReturnValue());
                
            }
        });
	 	$A.enqueueAction(action);
	}
})