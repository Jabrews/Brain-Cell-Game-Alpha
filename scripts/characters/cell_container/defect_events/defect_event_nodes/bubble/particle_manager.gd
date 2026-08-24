extends Node

# components
@onready var bubble_p_s : PackedScene = preload("res://scenes/characters/cell_container/defect_events/defect_event_nodes/bubble/bubble.tscn")
@onready var bubble_parent_node : Node = $BubbleParentNode
@onready var spawn_bubble_delay_timer : Timer = $SpawnDelay
@onready var spawn_positions : Array[Node3D]= [$SpawnPositions/SpawnPos1, $SpawnPositions/SpawnPos2, $SpawnPositions/SpawnPos3]
var current_bubble_color : Color = Color(0.826, 0.0, 0.111, 1.0)
@export var spawn_bubble_delay_wait_time : float = 1.0

func _ready() -> void:
	
	spawn_bubble_delay_timer.wait_time = spawn_bubble_delay_wait_time
	spawn_bubble_delay_timer.start()	
	
	spawn_bubble_delay_timer.connect('timeout', _handle_spawn_bubble_delay_timer)

func spawn_bubble() -> void:
	var spawn_num: int = randi_range(2, 3)
	
	var available_spawn_positions = spawn_positions.duplicate()
	available_spawn_positions.shuffle()
	
	for i in range(spawn_num):
		var bubble_instance: StaticBody3D = bubble_p_s.instantiate()
		
		bubble_instance.name = "bubble"
		bubble_instance.sprite_color = current_bubble_color
		
		bubble_parent_node.add_child(bubble_instance)
		
		var spawn_position: Node3D = available_spawn_positions[i]
		bubble_instance.global_position = spawn_position.global_position
	
func _handle_spawn_bubble_delay_timer(): 
	spawn_bubble()

	
func _handle_shake_progress(curr_shake_progess: float) -> void:
	
	match curr_shake_progess:
		0.25:
			current_bubble_color = Color(1.0, 0.25, 0.25)
		
		0.50:
			current_bubble_color = Color(1.0, 0.5, 0.5)
		0.75:
			current_bubble_color = Color.WHITE
		
		1.00:
			return
	
	
	kill_old_bubbles()
	spawn_bubble_delay_timer.stop()
	_handle_spawn_bubble_delay_timer()
	spawn_bubble_delay_timer.start()
			
func kill_old_bubbles() :
	for bubble : StaticBody3D in bubble_parent_node.get_children() :
		if bubble.sprite_color != current_bubble_color : 
			bubble.kill_bubble()
