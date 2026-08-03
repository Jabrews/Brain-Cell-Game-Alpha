extends Node

class_name AdminPanelRoot 
	
var id : int
var date_created : String
var test_data : TESTDATA

@warning_ignore("shadowed_variable")
func _init(
	id : int, 
	date_created : String,
	test_data: TESTDATA
) :
	self.id = id
	self.date_created = date_created
	self.test_data = test_data
	
func _to_string() -> String:
	return "[admin panel root] | id : %s | date created : %s | test data : %s " % [
		id,
		date_created,
		test_data,
	]

static func from_dictionary(
	data: Dictionary
) -> AdminPanelRoot:
	
	return AdminPanelRoot.new(
		int(data.get("id", 0)), # second var represents default argument 
		str(data.get("date_created", "")),
		data.get('test_data', null)
	)
	
func to_dictionary() -> Dictionary:
	return {
		"id": id,
		"date_created": date_created,
		"test_data": test_data 
	}
	
