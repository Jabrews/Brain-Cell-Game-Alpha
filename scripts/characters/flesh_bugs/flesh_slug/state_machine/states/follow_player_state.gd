extends Node

# components
@onready var parent_slug : CharacterBody3D = $"../.."
@onready var spawn_sound : AudioStreamPlayer3D = $"../../SpawnClickingSound"
@onready var state_machine : Node = $".."

var player_refrence : CharacterBody3D

func state_start() : 
	player_refrence = get_parent().get_node("Player")		

func state_process(_delta) : 
	
	# await getting player refrence
	if not player_refrence :
		return
	
	
	


func state_end() : 
	pass
