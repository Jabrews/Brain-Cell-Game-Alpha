extends Node

class_name CellNames 

var prisoner_names = [
	"Alex",
	"Jordan",
	"Taylor",
	"Casey",
	"Morgan",
	"Riley",
	"Cameron",
	"Dylan",
	"Logan",
	"Jamie",
	"Chris",
	"Blake",
	"Quinn",
	"Rowan",
	"Skyler",
	"Parker",
	"Reese",
	"Avery",
	"Kendall",
	"Shawn",
	"Hayden",
	"Emerson",
	"Finley",
	"Harper",
	"Jesse",
	"Lane",
	"Micah",
	"Noel",
	"Payton",
	"Phoenix",
	"River",
	"Sage",
	"Spencer",
	"Tatum",
	"Teagan",
	"Tristan",
	"Winter",
	"Arden",
	"Bellamy",
	"Briar",
	"Ellis",
	"Greer",
	"Hollis",
	"Indigo",
	"Jules",
	"Kai",
	"Lennon",
	"Marley",
	"Oakley",
	"Onyx",
	"Presley",
	"Remy",
	"Rory",
	"Sloane",
	"Stevie",
	"Sunny",
	"Zephyr",
	"Zion",
	"Arlo",
	"Blaine",
	"Cleo",
	"Dakota",
	"Ellery",
	"Frankie",
	"Gale",
	"Haven",
	"Ira",
	"Jaden"
]

var target_names = [
	'Torso',
	'Head',
	'Arms',
	'Legs',
]

func pick_prisoner_names() -> String:
	if prisoner_names.is_empty():
		push_error("no prisoner names left")
		return ""
	
	var index = randi_range(0, prisoner_names.size() - 1)
	var prisoner_name = prisoner_names[index]
	
	prisoner_names.remove_at(index)
	
	return prisoner_name

func pick_target_names() -> String  :
	
	if target_names.is_empty():
		push_error("no target names left")
		return ""
	
	var index = randi_range(0, target_names.size() - 1)
	var target_name = target_names[index]
	
	target_names.remove_at(index)
	
	return target_name 
	
