extends Node

@export var stat_type : String = 'strength'

# components
@onready var screen_hidden_interpreter : Node2D = $TvFrontPannel/SubViewport/ScreenHiddenInterpreter
@onready var progress_time_spent_manager : Node = $ProgressTimeSpentManager
@onready var jolt_particles : GPUParticles3D = $JoltParticles 


var loaded_cell_container : CharacterBody3D
var jolt_active : bool = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('debug2') : 
		_handle_defect_event_jolt_ended()
		


func _ready() -> void:
	screen_hidden_interpreter._switch_screen('no_cell_detected')
	
	GLDefectEventMangerBus.connect('event_hidden_stat_interpreter_jolt', _handle_defect_event_jolt)	
	

func _handle_panel_body_recieved(cell_container : CharacterBody3D) :
	
	loaded_cell_container = cell_container
	
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
		return
	if valid_stat_found : 
		screen_hidden_interpreter._switch_screen('progress_screen')
		progress_time_spent_manager._update('start')
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
			
			
func _handle_defect_event_jolt(selected_interpreters : Array): 	
	
	for selected_interpreter_type : String in selected_interpreters : 
		if selected_interpreter_type == stat_type:
			
			screen_hidden_interpreter._switch_screen('jolt_detected')
			
			progress_time_spent_manager._update('pause')
			
			jolt_particles.emitting = true
			
			jolt_active = true
			
			#audio_manager.toggle_play_jolt(true)
			#energy_decrease_spawner._start_spawning_decrease_particles(selected_interpreters)
			
			if loaded_cell_container:
				loaded_cell_container.switch_cell_state('jolt')

func _handle_defect_event_jolt_ended(lever_flipped : bool = false) :
	jolt_particles.emitting = false 
			
	jolt_active = false 
	
	# let event notice know we stopped jolt
	GLEventNoticeManagerBus.emit_signal('delete_event_notice_hidden_stat_interpreter', stat_type)
	
	# if cell is still on panel
	if loaded_cell_container : 
		
		loaded_cell_container.switch_cell_state('idle')
		
		# when lever is flipped we do reset progress
		if lever_flipped : 		
			progress_time_spent_manager._update('stop')
		
		progress_time_spent_manager._update('start')
	else : 
		progress_time_spent_manager._update('stop')
	
	# reset screen 
	_handle_panel_body_recieved(loaded_cell_container)
	
		
		
	
		
	
	
			
			
func _handle_discover_hidden() : 
	
	if not loaded_cell_container : 
		push_error('unable to find loaded cell container. although finished')
		return
		
	var designated_brain_cell : BrainCell = loaded_cell_container.designated_brain_cell
	
	GLCellManagerBus.emit_signal('hidden_stat_interpreted', designated_brain_cell,  stat_type)
	
	screen_hidden_interpreter._switch_screen('finished')
	
	
	
	
	
	


	
	
