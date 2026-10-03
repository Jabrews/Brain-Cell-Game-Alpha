extends Node

# components
@onready var parent_station : Node3D = $".."
@onready var handle_dissolving : Node = $"../HandleDissolving"

var dissolving_cell : DissolvingCell

func _create_inital_dissolving_cell(active_threshold_piece : ThresholdPiece) : 
	
	dissolving_cell = DissolvingCell.new(
		null, # corrisponding cell
		DissolvingStat.new('strength', 0, 0, active_threshold_piece.strength),
		DissolvingStat.new('intelligence', 0, 0, active_threshold_piece.intelligence), # (value/amount to decrease, defect)
		DissolvingStat.new('community', 0, 0, active_threshold_piece.community),
	)
	
	handle_dissolving._refresh()

func _create_dissolving_cell(elevator_cell_container: CharacterBody3D) :
	
	if not elevator_cell_container: 
		push_error('trying to create dissolve cell without elevator cell')
		return
	
	var active_threshold_piece : ThresholdPiece = parent_station.active_threshold_piece
	
	elevator_cell_container.spawn_flesh_bug_on_death = false
	
	var elevator_cell : BrainCell = elevator_cell_container.designated_brain_cell
	
	
	dissolving_cell = DissolvingCell.new(
		elevator_cell,
		DissolvingStat.new('strength', elevator_cell.strength.value, elevator_cell.strength.defect, active_threshold_piece.strength),
		DissolvingStat.new('intelligence', elevator_cell.intelligence.value, elevator_cell.intelligence.defect, active_threshold_piece.intelligence),
		DissolvingStat.new('community', elevator_cell.community.value, elevator_cell.community.defect, active_threshold_piece.community),
	)
	
	handle_dissolving._refresh()
		
	
	
