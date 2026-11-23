extends Node

# components
@onready var detect_cell_area : Area3D = $"../../Elevator/DetectCellArea"
@onready var parent_elevator_manager : Node = $".."

func _ready() -> void:
	detect_cell_area.connect('body_entered', _handle_body_entered) 
	detect_cell_area.connect('body_exited', _handle_body_exited) 
		

func _handle_body_entered(body : Node3D) : 
	
	if body.is_in_group('brain_cell_container') :
		
		parent_elevator_manager._handle_cell_added_to_elevator(body)
		
		

func _handle_body_exited(body : Node3D) : 
	
	if body.is_in_group('brain_cell_container') :
		
		parent_elevator_manager._handle_cell_removed_from_elevator(body)
