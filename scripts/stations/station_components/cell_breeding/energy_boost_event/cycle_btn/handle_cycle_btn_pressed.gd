extends Node

# cell manager componnets
@onready var main_cell_manager : Node = $"../../MainCellManager"
@onready var energy_boost_cell_manager : Node = $"../../MainCellManager/EnergyBoostCellManager"

# sync charge boost display 
@onready var sync_charge_boost_display : Node = $"../../SyncChargeBoostDisplay"

# helper 
@onready var handle_cycled_stat_validity : Node = $HandleCycledStatValidity

# direction event handler
@onready var handle_direction_btn_pressed : Node = $"../HandleDirectionBtnPressed"

# audio
@onready var left_audio_manager : Node3D = $"../../Audio/LeftAudioManager"
@onready var right_audio_manager : Node3D = $"../../Audio/RightAudioManager"


var left_index : int = -1
var right_index : int = -1

func _handle_event_cycle_btn_pressed(side : String, direction : String) :
	
	# main cell and energy boost cell exist
	var cell_exists = verify_cell_exist(side)

	if not cell_exists :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	# changes index
	cycle_stat(side, direction)	
	
	##### playing correct sound ####
	# kinda hacky #
	var curr_index : int 
	match side : 	
		'left' :
			curr_index = left_index
		'right' : 		
			curr_index = right_index
	
	var valid : bool = handle_cycled_stat_validity._check_stats_validity(side)
	
	# if none selected dont play invalid
	if curr_index == -1 :
		play_audio(side, 'cycle')
	# else we either play invalid or correct
	else :
		# update validity and manager stat
		
		if valid : 
			play_audio(side, 'cycle')
		else : 
			play_audio(side, 'invalid')
	###################################
	
	sync_charge_boost_display.sync_charge_boost_display()
	# update direction btns with new stat change
	handle_direction_btn_pressed._handle_boost_cell_stat_cycled(side)
	

func verify_cell_exist(side : String) -> bool : 
	
	var main_cell : BrainCell
	var energy_boost_cell : BrainCell
	
	match side :
		'left' :
			main_cell = main_cell_manager.main_left_cell
			energy_boost_cell = energy_boost_cell_manager.energy_boost_left_cell
		'right' :
			main_cell = main_cell_manager.main_right_cell
			energy_boost_cell = energy_boost_cell_manager.energy_boost_right_cell		
	
	if not main_cell or not energy_boost_cell: 
		return false
	else : 
		return true

func cycle_stat(side: String, direction: String) -> void:
	var index: int = _get_index_from_side(side)

	if index == -1:
		match direction:
			"up":
				index = 0
			"down":
				index = 2
	else:
		match direction:
			"up":
				index += 1
			"down":
				index -= 1

		if index < 0 or index > 2:
			index = -1

	_set_index_from_side(side, index)



### side to index getter ##
func _get_index_from_side(side: String) :
	match side:
		"left":
			return left_index
		"right":
			return right_index
###########################

## side to index setter ##
func _set_index_from_side(side: String, index: int) -> void:
	match side:
		"left":
			left_index = index
		"right":
			right_index = index
###########################
		

func _handle_reset_index_cell_removed(side : String) :		
	match side : 	
		'left' :
			left_index = -1
		'right' :
			right_index = -1
		
###########################	

## Audio helper ##
func play_audio(side: String, type : String) :

	var audio_manager : Node3D
	
	match side : 
		'left' :
			audio_manager = left_audio_manager
		'right' :
			audio_manager = right_audio_manager

	match type : 
		'cycle' :
			audio_manager.play_cycle()
		'invalid' :
			audio_manager.play_invalid_stat()
	
	
		
		
		





	
		
		
	
