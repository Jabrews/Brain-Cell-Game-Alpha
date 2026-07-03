extends Node


# componnets
@onready var parent_charge_seat : Node3D = $"../../../.."
# components helpers
@onready var display_cell : Node = $DisplayCell
@onready var cycle_selected_stat : Node = $CycleSelectedStat
@onready var toggle_stat_valid : Node = $ToggleStatValid

var selected_stat : String = 'none'
var selected_stat_valid : bool = false

	
func _brain_cell_recieved(brain_cell: BrainCell) -> void:
	
	if not brain_cell:
		selected_stat = "none"
		selected_stat_valid = toggle_stat_valid._verify_stat_valid(selected_stat) # also resets label
		cycle_selected_stat._reset_cell_removed()
	
	display_cell._handle_cell_recieved(brain_cell)
	
func _increment_cycle_btn_pressed(direction: String) -> void:
	selected_stat = cycle_selected_stat._handle_cycle_stat(direction)
	selected_stat_valid = toggle_stat_valid._verify_stat_valid(selected_stat)
	
	var selected_cell = parent_charge_seat.selected_brain_cell 
	
	if selected_stat_valid : 
		
		var after_chair_object_pair : Array =  GAMECellBreeder.reduced_cell_charge_helper._get_reduced(selected_cell, selected_stat)
		
		# let parent get new cell in its entirety with stat
		parent_charge_seat._handle_recieve_after_charge_cell(after_chair_object_pair[1])
		
		# load display with new stat
		display_cell._handle_cell_recieved(selected_cell, after_chair_object_pair[0])
		
	elif not selected_stat_valid : 
		parent_charge_seat._handle_recieve_after_charge_cell(null)
		# load display with new stat
		display_cell._handle_cell_recieved(selected_cell)
		
	
	
	
