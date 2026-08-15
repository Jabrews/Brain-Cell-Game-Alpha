extends Node

@export var stat_type : String = 'strength'

# components
@onready var screen_hidden_interpreter : Node2D = $TvFrontPannel/SubViewport/ScreenHiddenInterpreter
@onready var progress_time_spent_manager : Node = $ProgressTimeSpentManager
@onready var jolt_particles : GPUParticles3D = $JoltParticles 
@onready var energy_decrease_spawner : Node3D = $EnergyDecreaseSpawner
@onready var audio_manager : Node3D = $AudioManager

var loaded_cell_container : CharacterBody3D
var jolt_active : bool = false
var plugged_in : bool = true 


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug2') : 
		_handle_plug('in')
	elif Input.is_action_just_pressed('debug3') : 
		_handle_plug('out')
		


func _ready() -> void:
	screen_hidden_interpreter._switch_screen('no_cell_detected')
	
	GLDefectEventMangerBus.connect('event_hidden_stat_interpreter_jolt', _handle_defect_event_jolt)	
	

func _handle_panel_body_recieved(cell_container : CharacterBody3D) :
	
	loaded_cell_container = cell_container
	
	audio_manager.toggle_play_idle_drone(false)
	
	if not plugged_in : 
		return
	
	if jolt_active : 
		# if cell is picked up during jolt. reset progress
		if not cell_container: 
			progress_time_spent_manager._update('stop')
		return
	
	
	if not cell_container : 
		screen_hidden_interpreter._switch_screen('no_cell_detected')
		progress_time_spent_manager._update('stop')
		return
	
	
	var designated_brain_cell : BrainCell = cell_container.designated_brain_cell
	
	var valid_stat_found : bool = verify_cell_stat_valid(designated_brain_cell)
	
	if not valid_stat_found : 
		screen_hidden_interpreter._switch_screen('no_hidden_stat_detected')
		progress_time_spent_manager._update('stop')
		audio_manager.play_hidden_stat_invalid()
		return
	if valid_stat_found : 
		screen_hidden_interpreter._switch_screen('progress_screen')
		progress_time_spent_manager._update('start')
		audio_manager.play_stat_accepted()
		
		audio_manager.toggle_play_idle_drone(true)
		
		return
	


func verify_cell_stat_valid(brain_cell : BrainCell) -> bool : 
	
	match stat_type : 	
		'strength' :
			return brain_cell.strength.hidden and brain_cell.strength.enabled 
		'intelligence' :
			return brain_cell.intelligence.hidden and brain_cell.intelligence.enabled 
		'community' :
			return brain_cell.community.hidden and brain_cell.community.enabled 
		_ : 
			push_error('invalid stat type on interpreter found : ', stat_type)
			return false
			

func _handle_plug(plug_status : String) : 
	
	# handle time
	if loaded_cell_container : 
		progress_time_spent_manager._update('pause')
	else : 
		progress_time_spent_manager._update('stop')
		
	match plug_status : 
		'in' :
			plugged_in = true
			_handle_panel_body_recieved(loaded_cell_container)
		'out' : 
			plugged_in = false
			screen_hidden_interpreter._switch_screen('off')
			_handle_defect_event_jolt_ended(false)

				
			

			
func _handle_defect_event_jolt(selected_interpreters : Array): 	
	for selected_interpreter_type : String in selected_interpreters : 
		if selected_interpreter_type == stat_type:
			
			screen_hidden_interpreter._switch_screen('jolt_detected')
			
			progress_time_spent_manager._update('pause')
			
			jolt_particles.emitting = true
			
			jolt_active = true
			
			audio_manager.toggle_play_jolt(true)
			audio_manager.toggle_play_idle_drone(false)
			
			#audio_manager.toggle_play_jolt(true)
			energy_decrease_spawner._start_spawning_decrease_particles(selected_interpreters)
			
			if loaded_cell_container:
				loaded_cell_container.switch_cell_state('jolt')

func _handle_defect_event_jolt_ended(lever_flipped : bool = false) :
	jolt_particles.emitting = false 
			
	jolt_active = false 
	
	energy_decrease_spawner._stop_spawning_decrease_particles()
	
	audio_manager.toggle_play_jolt(false)
	
	# let event notice know we stopped jolt
	GLEventNoticeManagerBus.emit_signal('delete_event_notice_hidden_stat_interpreter', stat_type)
	
	# if cell is still on panel
	if loaded_cell_container : 
		loaded_cell_container.switch_cell_state('idle')
	
		# when lever is flipped we do reset progress
		if lever_flipped : 		
			progress_time_spent_manager._update('stop')
		
	else : 
		progress_time_spent_manager._update('stop')
	
	# reset screen 
	_handle_panel_body_recieved(loaded_cell_container)
			
func _handle_discover_hidden() : 
	
	if not loaded_cell_container : 
		push_error('unable to find loaded cell container. although finished')
		return
		
	audio_manager.play_finished()
		
	var designated_brain_cell : BrainCell = loaded_cell_container.designated_brain_cell
	
	GLCellManagerBus.emit_signal('hidden_stat_interpreted', designated_brain_cell,  stat_type)
	
	screen_hidden_interpreter._switch_screen('finished')
	
	
	
	
	
	


	
	
