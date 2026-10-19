extends Node

# components
@onready var parent_prisoner_showcase : Control = $".."
@onready var prisoner_generator_manager : Node = $"../PrisonerGeneratorManager"


func _handle(prisoner_card : PrisonerOfferCard) :
	
	parent_prisoner_showcase.visible = true
	
	prisoner_generator_manager._start(prisoner_card)
	
	
	
	
