extends Node

# components
@onready var audio_manager : Node3D = $AudioManager
@onready var screen_charge_seats : Node2D = $TV/TvFrontPannel/SubViewport/ScreenChargeSeat

@export var side : String
var selected_brain_cell : BrainCell
var after_charge_brain_cell : BrainCell


func _handle_brain_cell_recieved(cell : BrainCell) :
	
	selected_brain_cell = cell	
	
	screen_charge_seats._brain_cell_recieved(cell)
	
	if selected_brain_cell : 
		GLPlayerLocalSoundsBus.emit_signal('sound_panel_cell_loaded')

func _handle_cycle_btn_pressed(direction : String) :
	
	if not selected_brain_cell : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	else : 
		audio_manager.play_cycle()
		screen_charge_seats._increment_cycle_btn_pressed(direction)
		

func _handle_recieve_after_charge_cell(new_cell : BrainCell) :
	after_charge_brain_cell = new_cell
	
