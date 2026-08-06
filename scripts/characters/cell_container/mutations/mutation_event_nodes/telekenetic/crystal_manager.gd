extends Node3D

@onready var crystal_spawn_positions : Array[Node3D] = [
	$Pos1, $Pos2, $Pos3
]
@onready var parent_crystal_node : Node3D = $ParentCrystalNode
@onready var crystal_scene : PackedScene = preload("res://scenes/characters/cell_container/mutations/mutation_event_nodes/telekinetic/crystal.tscn")


var rotate_to_face_player : bool = true
var player_refrence : CharacterBody3D
@export var shoot_delay : float = 4.0

func _ready() -> void:
	player_refrence = GLPlayerState.player_refrence

func _process(_delta: float) -> void:
	if player_refrence and rotate_to_face_player : 	
		var player_glob_pos = player_refrence.global_position		
		look_at(player_glob_pos, Vector3.UP)
		
func _create() :
	
	var curr_index : int = 0
	
	while curr_index < 3 : 
		
			var crystal_instance : CharacterBody3D = crystal_scene.instantiate()
			parent_crystal_node.add_child(crystal_instance)
			crystal_instance.global_position = crystal_spawn_positions[curr_index].global_position
		
			curr_index += 1
		

func _attack_player() : 
	
	rotate_to_face_player = false
	
	for crystal : CharacterBody3D in parent_crystal_node.get_children() :
		
		crystal.state_machine.switch_state(crystal.state_machine.State.ATTACK)
		
		await get_tree().create_timer(shoot_delay).timeout		
		
	
	
	
	
	
