extends Node

# component states
@onready var inactive_state : Node = $States/Inactive
@onready var cell_recieved_state : Node = $States/CellRecieved
@onready var returning_cell_state : Node = $States/ReturningCell
@onready var confirm_dissolve_state : Node = $States/ConfirmDissolve
@onready var dissolve_finished_state : Node = $States/DissolveFinished

# components
@onready var handle_dissolve_cell : Node = $"../HelperDissolveCell"


var cell_container_on_elevator : CharacterBody3D

var current_elevator_state : String = 'inactive'
var active_state : Node 

var buttons_avaible : bool = false




func _handle_cell_added_to_elevator(cell_container : CharacterBody3D) : 
	
	if not cell_container_on_elevator : 	
		
		# dont allow untill its ready
		if current_elevator_state != 'inactive' :
			return
		
		cell_container_on_elevator = cell_container
		switch_state('cell_recieved')		
		

func _handle_cell_removed_from_elevator(cell_container : CharacterBody3D) :
	
	if cell_container_on_elevator == cell_container : 
		cell_container_on_elevator = null	

func _dissolving_cell_finished() :
	
	# if not already set
	cell_container_on_elevator = null	
	
	switch_state('dissolve_finished')

func switch_state(state: String) -> void:
	if state == current_elevator_state and active_state:
		return

	var next_state: Node

	match state:
		"inactive":
			next_state = inactive_state
		"cell_recieved":
			next_state = cell_recieved_state
		"returning_cell":
			next_state = returning_cell_state
		"confirm_dissolve":
			next_state = confirm_dissolve_state
			
			# START DISSOLVE			
			handle_dissolve_cell._create_dissolving_cell(cell_container_on_elevator)
			
		'dissolve_finished' :
			next_state = dissolve_finished_state
			
		_:
			push_error("Unable to find state: " + state)
			return

	if active_state:
		active_state._stop_state()
	
	current_elevator_state = state
	active_state = next_state

	if state == "cell_recieved" or state == "returning_cell":
		active_state._start_state(cell_container_on_elevator)
	elif state == 'dissolve_finished' : 
		active_state._start_state()
		await get_tree().create_timer(2.0).timeout		
		switch_state('inactive')		
	else:
		active_state._start_state()
	
## btn handlers

func _handle_confirm_btn_pressed() :
	
	if current_elevator_state != 'cell_recieved' or not buttons_avaible:
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
	
	switch_state('confirm_dissolve')
	
	## NOTE
	# isnt set back to returning cell and inactive untill dissolving done
	# called elsewhere
	

func _handle_deny_btn_pressed() : 
	
	if current_elevator_state != 'cell_recieved' or not buttons_avaible:
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
	
	switch_state('returning_cell')
	
	await get_tree().create_timer(2.0).timeout 
	
	if current_elevator_state == "returning_cell":
		switch_state("inactive")
	

		
