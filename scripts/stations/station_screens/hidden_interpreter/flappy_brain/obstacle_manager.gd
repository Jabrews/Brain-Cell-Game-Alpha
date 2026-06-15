extends Node


@export var tube_preload_scene : PackedScene 
@onready var spawn_obstacle_delay : Timer = $SpawnObstacleDelay
@onready var tube_spawner : Node2D =$"../TubeSpawner"
@onready var point_generator : Node = $"../PointGenerator"

func start_obstacle_manager(toggle_value : bool) :
	if not toggle_value : 
		spawn_obstacle_delay.wait_time = 2
		spawn_obstacle_delay.start()
	else : 
		spawn_obstacle_delay.stop()

	
func _on_spawn_obstacle_delay_timeout() -> void:
	
	
	var tube_instance = spawn_tubes()
	point_generator.generate_tube_points(tube_instance)
	
	# update delay
	spawn_obstacle_delay.wait_time = randi_range(IVFlappyBrain.spawn_obstacle_delay_min, IVFlappyBrain.spawn_obstacle_delay_max)
	spawn_obstacle_delay.start()
	
func spawn_tubes() :
	var tube_instance: Node2D = tube_preload_scene.instantiate()
	tube_spawner.add_child(tube_instance)
	return tube_instance
