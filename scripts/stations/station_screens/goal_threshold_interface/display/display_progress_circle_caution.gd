extends Node

@onready var blink_interval_timer : Timer = $BlinkIntervalTimer

# component display
@onready var progress_circle_labels : Array[Label] = [
	$"../Stats/Strength/ProgressCircle/PercantLabel",
	$"../Stats/Intelligence/ProgressCircle/PercantLabel",
	$"../Stats/Community/ProgressCircle/PercantLabel"
]

@onready var progress_circle_emergency : Array[Sprite2D] = [
	$"../Stats/Strength/ProgressCircle/Emergency",
	$"../Stats/Intelligence/ProgressCircle/Emergency",
	$"../Stats/Community/ProgressCircle/Emergency"
]

@onready var progress_circle_checkmarks : Array[Sprite2D] = [
	$"../Stats/Strength/ProgressCircle/CheckMark",
	$"../Stats/Intelligence/ProgressCircle/CheckMark",
	$"../Stats/Community/ProgressCircle/CheckMark"
]

# indexes of stats currently not decreasing
var active_caution_indexes : Array[int] = []

# shared blink state
var caution_active : bool = false


func _ready() -> void:
	blink_interval_timer.connect(
		"timeout",
		_handle_blink_interval_timer_timeout
	)


func _display(
	strength_is_decreasing : bool,
	intelligence_is_decreasing : bool,
	community_is_decreasing : bool
) -> void:
	
	active_caution_indexes.clear()
	
	# strength
	if not strength_is_decreasing:
		active_caution_indexes.append(0)
	
	# intelligence
	if not intelligence_is_decreasing:
		active_caution_indexes.append(1)
	
	# community
	if not community_is_decreasing:
		active_caution_indexes.append(2)
	
	
	# reset all displays first
	for index : int in range(3):
		progress_circle_labels[index].visible = true
		progress_circle_emergency[index].visible = false
	
	
	# if at least one stat is not decreasing
	if not active_caution_indexes.is_empty():
		
		if blink_interval_timer.is_stopped():
			caution_active = true
			blink_interval_timer.start()
		
		_load_caution_display()
	
	else:
		blink_interval_timer.stop()
		caution_active = false


func _display_checkmark(left_strength : int, left_intelligence : int, left_community : int) :
	
	if left_strength <= 0 : 	
		active_caution_indexes.erase(0)
		progress_circle_checkmarks[0].visible = true
		progress_circle_labels[0].visible = false
		progress_circle_emergency[0].visible = false
		
	
	if left_intelligence <= 0 :
		active_caution_indexes.erase(1)
		progress_circle_checkmarks[1].visible = true	
		progress_circle_labels[1].visible = false
		progress_circle_emergency[1].visible = false	
	
	if left_community <= 0 : 
		active_caution_indexes.erase(2)
		progress_circle_checkmarks[2].visible = true	
		progress_circle_labels[2].visible = false
		progress_circle_emergency[2].visible = false	
	


func _handle_blink_interval_timer_timeout() -> void:
	
	caution_active = not caution_active
	
	_load_caution_display()


func _load_caution_display() -> void:
	
	for index : int in active_caution_indexes:
		
		if caution_active:
			# emergency symbol
			progress_circle_labels[index].visible = false
			progress_circle_emergency[index].visible = true
		
		else:
			# normal percent display
			progress_circle_labels[index].visible = true
			progress_circle_emergency[index].visible = false
