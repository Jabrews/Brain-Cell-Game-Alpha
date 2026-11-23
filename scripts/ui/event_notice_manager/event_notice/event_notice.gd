extends Node

# components

@onready var parent_spot: Control = $".."
@onready var load_style: Node = $LoadStyle
@onready var popup_sound_manager : Node2D = $PopupSoundManager
@onready var header_label: Label =$NoticeBody/Header/Header
@onready var body_label: Label = $NoticeBody/Body/Default/Body
@onready var progress_dial: TextureRect = $NoticeBody/Header/ProgressDial
@onready var increment_progress_timer: Timer = $IncrementProgress
@onready var whoosh_sound : AudioStreamPlayer2D = $WhooshSound

## notice body components
# default
@onready var parent_default : Control = $NoticeBody/Body/Default
# cell death event
@onready var parent_bug_death : Control = $NoticeBody/Body/BugCellDeath
@onready var parent_default_death : Control = $NoticeBody/Body/DefCellDeath
@onready var bug_death_event_label : Label = $NoticeBody/Body/BugCellDeath/MarginContainer/HBoxContainesr/DefaultDeathEventLabel
@onready var default_death_event_label : Label =$NoticeBody/Body/DefCellDeath/HBoxContainesr/DefaultDeathEventLabel

var designated_event_notice: EventNotice

var is_finishing: bool = false


func _start(data : Dictionary) -> void : 
	
	#GLGameManagerBus.connect('process_next_round', _handle_next_round)	
	
	# Create unique materials
	header_label.material = header_label.material.duplicate()
	progress_dial.material = progress_dial.material.duplicate()

	var event_type: String = designated_event_notice.event_type

	load_style._load(event_type)

	header_label.text = get_header_text_from_type(event_type)
	
	## death event body (custom)
	if event_type == 'cell_death_event' : 
		
		body_label.visible = false
		
		if data['spawn_flesh_bug'] == true: 
			parent_bug_death.visible = true
			bug_death_event_label.text = data['cell_name'] + ",\nhas died"
		else : 
			parent_default_death.visible = true
			default_death_event_label.text = 'Cell Container, ' + data['cell_name'] + "\nHas Died"
	## default body text
	else : 
		parent_default.visible = true
		body_label.text = designated_event_notice.event_body_text

	increment_progress_timer.timeout.connect(
		_handle_increment_progress_timer_timeout
	)


	# default wait time applying based on type
	if designated_event_notice.wait_time_overide == 0.0 :
		increment_progress_timer.wait_time = get_wait_time_from_type(event_type)
	# else overide
	else : 
		increment_progress_timer.wait_time = designated_event_notice.wait_time_overide	
		
	increment_progress_timer.start()
	
	popup_sound_manager._play(event_type)


func get_header_text_from_type(event_type: String) -> String:
	match event_type:
		"defect_event":
			return "Defect Event\nDetected"

		"mutation_event":
			return "Mutation Event\nDetected"
		
		"age_warning":
			return "Cell Lifespan\nWarning"
		
		'turn_warning': 
			return "DANGER Turn\nWarning"
		
		'cell_death_event' : 
			return "ALERT CELL DEATH"
		

		"default":
			return "New Event\nDetected"

		_:
			push_error(
				"trouble finding event type : ",
				event_type
			)

			return "error"

func get_wait_time_from_type(event_type : String) -> float: 
	match event_type:
		"defect_event":
			return 0.5

		"mutation_event":
			return 0.5

		"age_warning":
			return 0.5
		
		"turn_warning" : 
			return 1.0
		
		'cell_death_event' : 
			return 1.0

		"default":
			return 1.0
		
		_:
			push_error(
				"trouble finding event type : ",
				event_type
			)

			return 0.5
	

func _handle_increment_progress_timer_timeout() -> void:
	if is_finishing:
		return

	var shader_material := progress_dial.material as ShaderMaterial

	var curr_shader_value: float = shader_material.get_shader_parameter(
		"progress"
	)

	curr_shader_value += 0.1

	if curr_shader_value >= 1.0:
		curr_shader_value = 1.0

		shader_material.set_shader_parameter(
			"progress",
			curr_shader_value
		)

		_handle_progress_complete()
		return

	shader_material.set_shader_parameter(
		"progress",
		curr_shader_value
	)


func _handle_progress_complete() -> void:
	if is_finishing:
		return

	is_finishing = true

	increment_progress_timer.stop()

	# Its direct parent is the CURRENT spot.
	var current_spot: Control = get_parent()

	if not is_instance_valid(current_spot):
		return

	var event_notice_manager: Node = current_spot.parent_event_notice_manager


	var exit_tween := create_tween()

	exit_tween.tween_property(
		self,
		"position:x",
		150.0,
		0.7
	)

	exit_tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		0.7
	)
	
	whoosh_sound.play()

	await exit_tween.finished
	
	if not is_instance_valid(self):
		return

	# It could theoretically have moved during the fade,
	# so retrieve its current spot again.
	current_spot = self.get_parent()

	if is_instance_valid(current_spot):
		current_spot.spot_is_occupied = false
		
	self.queue_free()
	
	

	if is_instance_valid(event_notice_manager):
		event_notice_manager.call_deferred(
			"_handle_spot_freed"
		)

#func _handle_next_round() -> void:
	#increment_progress_timer.stop()
#
	#if is_finishing:
		#return
#
	#_handle_progress_complete()
	
func _delete_early() -> void : 	
	increment_progress_timer.stop()

	if is_finishing:
		return

	_handle_progress_complete()
