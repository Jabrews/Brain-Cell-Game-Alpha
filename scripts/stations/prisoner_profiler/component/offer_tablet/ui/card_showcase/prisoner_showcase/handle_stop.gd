extends Node

# components
@onready var parent_prisoner_showcase : Control = $".."
@onready var prisoner_generator_manager : Node = $"../PrisonerGeneratorManager"

func _handle() : 
	parent_prisoner_showcase.visible = false
	
	prisoner_generator_manager._stop()
