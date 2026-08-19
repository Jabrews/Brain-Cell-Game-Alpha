extends Node


# Door buttons
@export var door_buttons: Array[Node3D] = []

# Door components
@onready var door: StaticBody3D = $Door
@onready var open_pos: Node3D = $OpenPos
@onready var close_pos: Node3D = $ClosePos
@onready var open_duration_timer: Timer = $OpenDuration
@onready var lock_open_duration_timer: Timer = $LockOpenDuration
@onready var detect_entity_area: Area3D = $DetectEntityArea

# Door light
@onready var door_light: Node3D = $DoorLight

# Sounds
@onready var s_door_open: AudioStreamPlayer3D = $Audio/DoorOpen
@onready var s_door_open_layer: AudioStreamPlayer3D = $Audio/DoorOpenLayer
@onready var s_door_close: AudioStreamPlayer3D = $Audio/DoorClose


const OPEN_DURATION: float = 0.5
const ENTITY_DETECTION_DELAY: float = 0.1

@export var open_wait_time: float = 3.0
@export var lock_open_wait_time: float = 5.0

var door_open: bool = false
var door_locked: bool = false


func _ready() -> void:
	open_duration_timer.wait_time = open_wait_time
	lock_open_duration_timer.wait_time = lock_open_wait_time


func _open_door() -> void:

	if door_locked or door_open:
		return

	door_open = true

	await _open_door_sequence(
		open_duration_timer,
		"open",
		"closed"
	)

	door_open = false


func _lock_door() -> void:

	if door_locked:
		return

	door_locked = true
	door_open = true

	await _open_door_sequence(
		lock_open_duration_timer,
		"open",
		"locked"
	)

	door_open = false


func _unlock_door() -> void:

	door_locked = false
	switch_door_button_screen("closed")


func _open_door_sequence(
	duration_timer: Timer,
	open_screen: String,
	close_screen: String
) -> void:

	# Open
	_play_open_sounds()

	var open_tween := create_tween()
	open_tween.tween_property(
		door,
		"position:y",
		open_pos.global_position.y,
		OPEN_DURATION
	)

	switch_door_button_screen(open_screen)

	await open_tween.finished

	# Stay open
	duration_timer.start()
	door_light._start()

	await duration_timer.timeout

	# Close
	s_door_close.play()

	var close_tween := create_tween()
	close_tween.tween_property(
		door,
		"position:y",
		close_pos.global_position.y,
		OPEN_DURATION
	)

	# Check entities while the door is almost closed
	await get_tree().create_timer(ENTITY_DETECTION_DELAY).timeout
	detect_entity_area._detect_entitys_in_door()

	switch_door_button_screen(close_screen)

	await close_tween.finished

	door_light._stop()


func _play_open_sounds() -> void:

	s_door_open.play()
	s_door_open_layer.play()


func switch_door_button_screen(screen_type: String) -> void:

	for door_button: Node3D in door_buttons:
		door_button.button_screen._switch_screen(screen_type)
