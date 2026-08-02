extends Node


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :	
		print('stats to hide : ', IVHiddenStats.stats_to_hide)
	
			
	if Input.is_action_just_pressed('debug2') :	
		pass
