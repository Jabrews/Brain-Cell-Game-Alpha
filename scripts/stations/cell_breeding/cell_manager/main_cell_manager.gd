extends Node

# display componnet
@onready var sync_breeding_display : Node = $"../SyncBreedingDisplay"
@onready var sync_charge_boost_display : Node = $"../SyncChargeBoostDisplay"

# child energy boost cell manager
@onready var energy_boost_cell_manager : Node = $EnergyBoostCellManager

# check energy boost componnets
@onready var left_charge_panel_cell_area : Area3D = $"../ChargeSeats/ChargeSeatLeft/LoadPanelCell"
@onready var right_charge_panel_cell_area : Area3D = $"../ChargeSeats/ChargeSeatRight/LoadPanelCell"



var main_left_cell : BrainCell
var main_right_cell : BrainCell


func _handle_breeding_panel_cell_recieved(brain_cell: BrainCell, side: String) -> void:
	match side:
		"left":
			main_left_cell = brain_cell

			if main_left_cell == null:
				energy_boost_cell_manager._main_cell_removed(side)
				
			if main_left_cell: 
				refresh_energy_boost_panel_for_cell('left')

		"right":
			main_right_cell = brain_cell

			if main_right_cell == null:
				energy_boost_cell_manager._main_cell_removed(side)
			
			if main_right_cell: 
				refresh_energy_boost_panel_for_cell('right')
			

	sync_breeding_display.sync_breeding_cell_display()
	
	
func refresh_energy_boost_panel_for_cell(side: String) -> void:
	var area
	
	match side:
		"left":
			area = left_charge_panel_cell_area
		"right":
			area = right_charge_panel_cell_area

	area.set_deferred("monitoring", false)
	await get_tree().create_timer(0.1).timeout
	area.set_deferred("monitoring", true)




	
	
