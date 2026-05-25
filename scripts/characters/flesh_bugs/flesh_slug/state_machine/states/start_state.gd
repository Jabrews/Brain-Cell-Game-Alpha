extends Node

# components
@onready var parent_slug : CharacterBody3D = $"../.."
@onready var spawn_sound : AudioStreamPlayer3D = $"../../SpawnClickingSound"
@onready var state_machine : Node = $".."


func state_start() : 
	spawn_sound.play()
	parent_slug.can_be_hurt = false
	
	await get_tree().create_timer(1.0).timeout
	
	state_machine.switch_state(state_machine.State.FOLLOW_PLAYER)
	


func state_process(_delta) : 
	pass


func state_end() : 
	parent_slug.can_be_hurt = true 
