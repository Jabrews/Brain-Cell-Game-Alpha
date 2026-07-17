extends Node

# components
@onready var cell_manager : Node = $"../GameManager/CellManager"



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :	
		pass
			
			
	if Input.is_action_just_pressed('debug2') :	
		pass
