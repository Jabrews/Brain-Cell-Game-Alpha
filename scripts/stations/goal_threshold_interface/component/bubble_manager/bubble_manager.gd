
extends Node

# Components
@onready var spawn_points: Array[Node3D] = [
	$BubbleSpawnPoint,
	$BubbleSpawnPoint2,
	$BubbleSpawnPoint3,
	$BubbleSpawnPoint4,
	$BubbleSpawnPoint5
]
@onready var spawn_bubble_timer: Timer = $SpawnBubbleTimer
@onready var bubble_parent_node: Node = $BubbleParentNode
@onready var bubble_scene: PackedScene = preload(
	"res://scenes/stations/goal_threshold_interface/component/bubble.tscn"
)
@onready var tiny_dots_parent : Node3D = $TinyDotsParent

var last_spawn_point: Node3D

# Timer variety
const SPAWN_WAIT_TIME_MIN: float = 0.1
const SPAWN_WAIT_TIME_MAX: float = 0.2

# Bubble variety
const SCALE_MIN: float = 1.0
const SCALE_MAX: float = 1.25

const LIFETIME_MIN: float = 0.4
const LIFETIME_MAX: float = 1.5

const SPEED_MIN: float = 2.0
const SPEED_MAX: float = 2.5


func _ready() -> void:
	spawn_bubble_timer.wait_time = randf_range(
		SPAWN_WAIT_TIME_MIN,
		SPAWN_WAIT_TIME_MAX
	)
	spawn_bubble_timer.timeout.connect(_handle_spawn_bubble_timer_timeout)
	

func _toggle_bubbles(toggle_value: bool) -> void:
	if toggle_value:
		
		tiny_dots_parent.visible = true	
		
		if spawn_bubble_timer.is_stopped():
			spawn_bubble_timer.start()
	else:
		
		
		spawn_bubble_timer.stop()

		for bubble: AnimatedSprite3D in bubble_parent_node.get_children():
			bubble.pop()


func _handle_spawn_bubble_timer_timeout() -> void:
	var available_points: Array[Node3D] = []

	for spawn_point: Node3D in spawn_points:
		if spawn_point != last_spawn_point:
			available_points.append(spawn_point)

	if available_points.is_empty():
		available_points = spawn_points.duplicate()

	if available_points.is_empty():
		return

	var selected_spawn_point: Node3D = available_points.pick_random()
	last_spawn_point = selected_spawn_point

	var bubble: AnimatedSprite3D = bubble_scene.instantiate()
	bubble_parent_node.add_child(bubble)
	bubble.global_position = selected_spawn_point.global_position

	bubble.initialize_bubble(
		randf_range(LIFETIME_MIN, LIFETIME_MAX),
		randf_range(SCALE_MIN, SCALE_MAX),
		randf_range(SPEED_MIN, SPEED_MAX)
	)

	# Choose a new interval for the next bubble.
	spawn_bubble_timer.wait_time = randf_range(
		SPAWN_WAIT_TIME_MIN,
		SPAWN_WAIT_TIME_MAX
	)
	spawn_bubble_timer.start()
