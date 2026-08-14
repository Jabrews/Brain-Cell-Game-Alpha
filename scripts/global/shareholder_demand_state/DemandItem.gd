extends Node

class_name DemandItem 

var demand_type : String
var demand_name : String  
var demand_text : String


@warning_ignore("shadowed_variable")
func _init(
	demand_type: String,
	demand_name : String,
	demand_text: String,
):
	demand_type = demand_type 
	demand_name = demand_name 
	demand_text = demand_text 


func _to_string() -> String:
	return (
		"demand item (" +
		"type=" + demand_type+
		", name=" + demand_name +
		", text =" + demand_text +
		")"
	)
