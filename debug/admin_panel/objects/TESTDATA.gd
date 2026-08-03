extends Node

class_name TESTDATA 

var color : String

@warning_ignore("shadowed_variable")
func _init(
	color  : String 
) :
	self.color = color


func _to_string() -> String:
	return "[test data] | color : %s" % [
		color,
	]
#
static func from_dictionary(data: Dictionary) -> TESTDATA:
	return TESTDATA.new(
		str(data.get("color", ""))
	)

func to_dictionary() -> Dictionary:
	return {
		"color": color
	}



	
	
	

	
	
	
