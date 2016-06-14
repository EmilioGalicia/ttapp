({
	getEntries : function (component) {
		var action = component.get("c.findEntries");
		action.setParams({
			"objectID" : component.get("v.recordId")
		});
		action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.timeEntries", response.getReturnValue());
                
            }
        });
	 	$A.enqueueAction(action);
	}
})