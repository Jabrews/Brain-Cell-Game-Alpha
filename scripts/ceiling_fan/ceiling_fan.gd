extends Node3D

@export var room : String

@onready var detect_cell_area : Area3D = $DetectCellArea
@onready var container_breaking : AudioStreamPlayer3D = $ContainerBreaking

var designated_ceiling_fan_placement : CeilingFanPlacement 



func _ready() -> void:
	detect_cell_area.connect('body_entered', _handle_body_entered)
	
	designated_ceiling_fan_placement = CeilingFanPlacement.new(
		room,		
		global_position
	)	
	

func _handle_body_entered(body : Node3D) : 
	if body.is_in_group('brain_cell_container') : 
		body.spawn_flesh_bug_on_death = false
		body.kill_cell()
		container_breaking.play()
			
		
		
		
		
