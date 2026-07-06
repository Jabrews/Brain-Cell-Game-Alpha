extends Node

# componnet cell managers
@onready var energy_boost_cell_manager : Node = $"../MainCellManager/EnergyBoostCellManager"

# charge boost display loader
@onready var left_screen_charge_handle_display : Node = $"../ChargeSeats/ChargeSeatLeft/TV/TvFrontPannel/SubViewport/ScreenChargeBoostSeat/HandleDisplay"
@onready var right_screen_charge_handle_display : Node = $"../ChargeSeats/ChargeSeatRight/TV/TvFrontPannel/SubViewport/ScreenChargeBoostSeat/HandleDisplay"

# event manager cycled btn 
@onready var handle_cycle_btn_pressed : Node = $"../EnergyBoostEventManager/HandleCycleBtnPressed"


func sync_charge_boost_display() :
	
	# get cell
	var energy_boost_left_cell : BrainCell = energy_boost_cell_manager.energy_boost_left_cell 
	var energy_boost_right_cell : BrainCell = energy_boost_cell_manager.energy_boost_right_cell 
	
	# get cycled stat index
	var cycled_index_left : int = handle_cycle_btn_pressed.left_index 
	var cycled_index_right : int = handle_cycle_btn_pressed.right_index
	
	# get cycled stat 
	var cycled_stat_left : String = energy_boost_cell_manager.energy_boost_left_stat
	var cycled_stat_right : String = energy_boost_cell_manager.energy_boost_right_stat
	
	
	
	left_screen_charge_handle_display._handle_display(energy_boost_left_cell, cycled_index_left, cycled_stat_left)
	right_screen_charge_handle_display._handle_display(energy_boost_right_cell, cycled_index_right, cycled_stat_right)

	
	
	
	
	
	
