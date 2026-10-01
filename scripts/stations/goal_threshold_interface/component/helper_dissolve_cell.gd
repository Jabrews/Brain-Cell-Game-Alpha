extends Node

# components
#@onready var handle_dissolving : Node = $"../HandleDissolving"
@onready var handle_dissolving : Node = $"../HandleDissolving"

var dissolving_cell : DissolvingCell

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') : 
		dissolving_cell.strength_dissolving_stat.print_info()
		dissolving_cell.intelligence_dissolving_stat.print_info()



func _create_inital_dissolving_cell(active_threshold_piece : ThresholdPiece) : 
	
	dissolving_cell = DissolvingCell.new(
		null, # corrisponding cell
		DissolvingStat.new('strength', 100, 1, active_threshold_piece.strength),
		DissolvingStat.new('intelligence', 150, 10, active_threshold_piece.intelligence),
		DissolvingStat.new('community', 0, 0, active_threshold_piece.community),
	)
	
	handle_dissolving._refresh()

	
	
