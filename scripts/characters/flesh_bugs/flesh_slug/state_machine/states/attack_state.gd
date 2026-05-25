extends Node

# components
@onready var parent_slug : CharacterBody3D = $"../.."
@onready var state_machine : Node = $".."
@onready var tail_rattle_sound : AudioStreamPlayer3D = $"../../TailRattleSound"
@onready var bite_sound : AudioStreamPlayer3D = $"../../BiteSound"


func state_start() : 
	tail_rattle_sound.play()
	
	# scale up PLACEHOLDER FOR MODEL
	parent_slug.scale = Vector3(1.5, 1.5, 1.5)
	
	# bite delay
	await get_tree().create_timer(0.5).timeout
	
	bite_sound.play()


func state_process(_delta) : 
	pass


func state_end() : 
	tail_rattle_sound.stop()
	
	# scale up PLACEHOLDER FOR MODEL
	parent_slug.scale = Vector3(1, 1, 1)
