extends Node


func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed('debug1') :	
		pass
		
	if Input.is_action_just_pressed('debug2') :	
		pass
	
	if Input.is_action_just_pressed('debug3') :	
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

## TESTING EVENT NOTICE
#if Input.is_action_just_pressed('debug1') :	
	#var cell_name : String = 'yestzermstein'
	#GLEventNoticeManagerBus.emit_signal('create_event_notice', EventNotice.new('cell_death_event', '', {'spawn_flesh_bug' : false, 'cell_name' : cell_name}, 0.5))		
	#
#if Input.is_action_just_pressed('debug2') :	
	#var cell_name : String = 'yestzermstein'
	#GLEventNoticeManagerBus.emit_signal('create_event_notice', EventNotice.new('cell_death_event', '', {'spawn_flesh_bug' : true, 'cell_name' : cell_name}, 0.5))		
#
#if Input.is_action_just_pressed('debug3') :	
	#GLEventNoticeManagerBus.emit_signal('create_event_notice', EventNotice.new('turn_warning', 'Finale Turn. Last chance to reach Stat Goal', {}))
