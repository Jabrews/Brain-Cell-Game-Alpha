extends StaticBody3D 

@onready var parent_prisoner : CharacterBody3D = $".."

func _handle_interacted() : 
	parent_prisoner.handle_cell_interacted()
	
	
	
