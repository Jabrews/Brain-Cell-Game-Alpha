extends Node

# Components
@onready var audio_manager: Node3D = $AudioManager
# screen 
@onready var screen_charge_seats: Node2D = $TV/TvFrontPannel/SubViewport/ScreenChargeSeat
# main station
@onready var parent_breeding_station: Node3D = $"../.."
# main station helpers
@onready var direction_btn_controller: Node = $"../../DirectionBtnController"
@onready var load_charge_stat : Node = $"../../LoadChargeStat"

@export var side: String

var selected_brain_cell: BrainCell
var after_charge_brain_cell: BrainCell


func _handle_brain_cell_recieved(cell: BrainCell) -> void:
	if cell and not _can_load_cell_on_this_side():
		GLBreedingComponetsBus.emit_signal("breeding_station_feedback_requested", side, 'no_main_breeder_cell_found')
		return
	
	selected_brain_cell = cell
	_set_after_charge_cell(null)
	
	screen_charge_seats._brain_cell_recieved(selected_brain_cell)
	
	if selected_brain_cell:
		GLPlayerLocalSoundsBus.emit_signal("sound_panel_cell_loaded")


# from the main station when main breeding cell is removed
func _handle_breeding_panel_cell_removed() -> void:
	
	if selected_brain_cell != null	 :
		GLBreedingComponetsBus.emit_signal('breeding_station_feedback_requested', side, 'main_breeder_cell_removed')
	
	selected_brain_cell = null
	_set_after_charge_cell(null)
	
	screen_charge_seats._brain_cell_recieved(null)
	


func _handle_cycle_btn_pressed(direction: String) -> void:
	if not selected_brain_cell:
		GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
		return
	
	audio_manager.play_cycle()
	screen_charge_seats._increment_cycle_btn_pressed(direction)
	load_charge_stat._handle_new_energy_seat_stat_chosen(side, screen_charge_seats.selected_stat, screen_charge_seats.selected_stat_valid )

func _handle_recieve_after_charge_cell(new_cell: BrainCell) -> void:
	_set_after_charge_cell(new_cell)


func _set_after_charge_cell(new_cell: BrainCell) -> void:
	after_charge_brain_cell = new_cell
	direction_btn_controller._handle_charged_cell_recieved(side, after_charge_brain_cell)


func _can_load_cell_on_this_side() -> bool:
	match side:
		"left":
			return parent_breeding_station.left_cell != null
		
		"right":
			return parent_breeding_station.right_cell != null
		
		_:
			return false
	
	
	
