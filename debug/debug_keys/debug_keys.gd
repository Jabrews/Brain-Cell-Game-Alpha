extends Node


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :	
		pass

			
	if Input.is_action_just_pressed('debug2') :	
		pass
		
## SAVED NEXT GOAL PEICE INCR VALUE##
# NOTICE wont exactly update goal panel correctly, just loads new incr values
	#var goal_threshold: GoalThreshold = GLGoalThresholdManagerBus.active_goal_threshold
	#goal_threshold.active_piece_index += 1
	#GLGameManagerBus.emit_signal('proceed_next_goal_piece')

## DEBUG MOUSE HOVER 
# NOTICE ideal for when overlapping debugging
	#var control := get_viewport().gui_get_hovered_control()
	
	#if control:
		#print("Blocking/hovered Control: ", control.get_path())
		#print("Mouse Filter: ", control.mouse_filter)
	#else:
		#print("No Control detected")
		#pass
