extends Node

# components
@onready var cell_manager : Node = $"../GameManager/CellManager"



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :	
		var cells : Array[BrainCell]= cell_manager.prisoner_cells 
		for cell in cells : 
			print('cell name : ', cell.name)
			print('cell mutation : ', cell.mutation)
	
	if Input.is_action_just_pressed('debug2') :	
		pass
