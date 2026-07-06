extends Node

# Display components
@onready var sync_breeding_display: Node = $"../../SyncBreedingDisplay"
@onready var sync_charge_boost_display: Node = $"../../SyncChargeBoostDisplay"

# Parent manager
@onready var parent_main_cell_manager: Node = $".."

# event manager cycle btn
@onready var handle_cycle_btn_pressed : Node = $"../../EnergyBoostEventManager/HandleCycleBtnPressed"



var energy_boost_left_cell: BrainCell
var energy_boost_right_cell: BrainCell

var energy_boost_left_stat: String = "none"
var energy_boost_right_stat: String = "none"

var energy_boost_left_direction: String = "none"
var energy_boost_right_direction: String = "none"


func _handle_breeding_panel_cell_recieved(brain_cell: BrainCell, side: String) -> void:
	match side:
		"left":
			set_left_energy_boost_cell(brain_cell)

		"right":
			set_right_energy_boost_cell(brain_cell)
	
	# reset index from cycle stat if cell remoeved
	if not brain_cell : 
		handle_cycle_btn_pressed._handle_reset_index_cell_removed(side)
	
	sync_breeding_display.sync_breeding_cell_display()
	sync_charge_boost_display.sync_charge_boost_display()

func _main_cell_removed(side : String) :
	match side : 
		'left' :
			energy_boost_left_cell = null
			energy_boost_left_direction = 'none'
			energy_boost_left_stat = 'none'
		'right' :
			energy_boost_right_cell = null
			energy_boost_right_direction = 'none'
			energy_boost_right_stat = 'none'
	
	handle_cycle_btn_pressed._handle_reset_index_cell_removed(side)
	sync_charge_boost_display.sync_charge_boost_display()

func set_left_energy_boost_cell(brain_cell: BrainCell) -> void:
	energy_boost_left_stat = "none"
	energy_boost_left_direction = "none"

	var has_main_cell: bool = parent_main_cell_manager.main_left_cell != null

	if has_main_cell:
		energy_boost_left_cell = brain_cell
	else:
		energy_boost_left_cell = null
		# TODO: emit feedback signal that left boost cell cannot be accepted


func set_right_energy_boost_cell(brain_cell: BrainCell) -> void:
	energy_boost_right_stat = "none"
	energy_boost_right_direction = "none"

	var has_main_cell: bool = parent_main_cell_manager.main_right_cell != null

	if has_main_cell:
		energy_boost_right_cell = brain_cell
	else:
		energy_boost_right_cell = null
		# TODO: emit feedback signal that right boost cell cannot be accepted
