extends Node

@onready var ceiling_fans : Array[Node3D]= [
	$CeilingFan, $CeilingFan2, $CeilingFan3
]

func _ready() -> void:
	
	#load celing fan coordinates	
	var ceiling_fan_placements : Array[CeilingFanPlacement]
	
	for ceiling_fan : Node3D in ceiling_fans : 	
		var designated_ceiling_fan_placement = ceiling_fan.designated_ceiling_fan_placement
		ceiling_fan_placements.append(designated_ceiling_fan_placement)
		
	GLCeilingFanPlacementsState.ceiling_fan_placements = ceiling_fan_placements
	
	
	
	
	
		
		
		
	
	
	
	
	
	
	
	
	
	
	
