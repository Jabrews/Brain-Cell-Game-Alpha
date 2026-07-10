extends Node

@onready var s_splash : AudioStreamPlayer3D = $Splash
@onready var s_bubble : AudioStreamPlayer3D = $Bubble

func _play_cell_added_to_trash() :
	await get_tree().create_timer(0.2).timeout
	s_splash.play()
	await s_splash.finished
	await get_tree().create_timer(0.5).timeout
	s_bubble.play()
