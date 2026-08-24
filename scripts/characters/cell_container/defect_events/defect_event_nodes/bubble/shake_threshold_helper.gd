extends Node

# components
@onready var parent_bubble_defect_event: Node3D = $".."
@onready var s_shake_rattle: AudioStreamPlayer3D = $"../Sounds/ShakeRattle"
@onready var s_bubble_idle: AudioStreamPlayer3D = $"../Sounds/BubbleIdle"


# shake settings
@export var shake_completion_value: float = 100.0
@export var shake_sensitivity: float = 1.0
@export var movement_threshold: float = 0.01


# shake state
var current_shake_completion_value: float = 0.0
var previous_position: Vector3
var next_progress_threshold: float = 0.25

var cell_picked_up: bool = false
var parent_cell_container: CharacterBody3D


func _ready() -> void:
	parent_cell_container = parent_bubble_defect_event.parent_brain_cell_container
	previous_position = parent_cell_container.global_position


func _toggle_detect_shake_threshold(toggle_value: bool) -> void:
	cell_picked_up = toggle_value
	
	if toggle_value:
		previous_position = parent_cell_container.global_position
		s_bubble_idle.stop()
	else:
		_stop_shake_rattle()
		_play_idle_pop()


func _process(_delta: float) -> void:
	if not cell_picked_up or not parent_cell_container:
		_stop_shake_rattle()
		_play_idle_pop()
		return
	
	
	var current_position: Vector3 = parent_cell_container.global_position
	
	# Count movement on X and Y.
	var movement: Vector2 = Vector2(
		current_position.x - previous_position.x,
		current_position.y - previous_position.y
	)
	
	var movement_amount: float = movement.length()
	
	
	# Audio
	
	if movement_amount > movement_threshold:
		# Cell is moving.
		s_bubble_idle.stop()
		
		if not s_shake_rattle.playing:
			s_shake_rattle.play()
	else:
		# Cell has stopped moving.
		_stop_shake_rattle()
		_play_idle_pop()
	
	
	# Shake progress
	
	current_shake_completion_value += (
		movement_amount * shake_sensitivity
	)
	
	previous_position = current_position
	
	current_shake_completion_value = min(
		current_shake_completion_value,
		shake_completion_value
	)
	
	_check_shake_progress()


func _check_shake_progress() -> void:
	var progress: float = (
		current_shake_completion_value / shake_completion_value
	)
	
	if progress >= next_progress_threshold:
		
		parent_bubble_defect_event._update_shake_progress(
			next_progress_threshold
		)
		
		#next_progress_threshold += 0.25
		next_progress_threshold += 0.25
	
		if next_progress_threshold == 1.0 : 	
			s_bubble_idle.volume_db = -50.0
			s_shake_rattle.volume_db = -50.0
	


func _stop_shake_rattle() -> void:
	if s_shake_rattle.playing:
		s_shake_rattle.stop()


func _play_idle_pop() -> void:
	if not s_bubble_idle.playing:
		s_bubble_idle.play()
