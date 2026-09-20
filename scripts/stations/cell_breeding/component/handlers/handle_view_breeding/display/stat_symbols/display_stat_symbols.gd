extends Node

# helper components
@onready var handle_hidden : Node = $HandleHidden
@onready var handle_arrow : Node = $HandleArrow

# visual components
@onready var up_arrows : Array[Sprite2D] = [
	$"../../../BreedingUI/CellLoader/BreedingView/StatDisplay/ArrowUp/UpStrength", 
	$"../../../BreedingUI/CellLoader/BreedingView/StatDisplay/ArrowUp/UpIntelligence", 
	$"../../../BreedingUI/CellLoader/BreedingView/StatDisplay/ArrowUp/UpCommunity"
]
@onready var down_arrows : Array[Sprite2D] = [
	$"../../../BreedingUI/CellLoader/BreedingView/StatDisplay/ArrowDown/DownStrength",
	$"../../../BreedingUI/CellLoader/BreedingView/StatDisplay/ArrowDown/DownIntelligence",
	$"../../../BreedingUI/CellLoader/BreedingView/StatDisplay/ArrowDown/DownCommunity"
]
@onready var hidden_question_mark_sprites : Array[Sprite2D] = [
	$"../../../BreedingUI/CellLoader/BreedingView/StatDisplay/QuestionMark/QuestionStrength",
	$"../../../BreedingUI/CellLoader/BreedingView/StatDisplay/QuestionMark/QuestionIntelligence", 
	$"../../../BreedingUI/CellLoader/BreedingView/StatDisplay/QuestionMark/QuestionCommunity"
]




func check_for_symbols(cell_1 : BrainCell, cell_2 : BrainCell) -> void:

	var stats_1 = [
		cell_1.strength,
		cell_1.intelligence,
		cell_1.community
	]

	var stats_2 = [
		cell_2.strength,
		cell_2.intelligence,
		cell_2.community
	]

	for i in range(3):
		var has_hidden_stat = handle_hidden._handle(
			stats_1[i],
			stats_2[i]
		)

		if not has_hidden_stat:
			handle_arrow._handle(
				stats_1[i],
				stats_2[i],
				i
			)
	

func hide_symbols() -> void:
	for symbol : Sprite2D in up_arrows : 
		symbol.visible = false
	
	for symbol : Sprite2D in down_arrows : 
		symbol.visible = false
	
	for symbol : Sprite2D in hidden_question_mark_sprites : 
		symbol.visible = false
		
	
	

	
	
