extends Node

# components
@onready var s_elevator_moving : AudioStreamPlayer3D = $ElevatorMoving
@onready var s_elevator_arrive : AudioStreamPlayer3D = $ElevatorArrive
@onready var s_lid_open : AudioStreamPlayer3D = $LidOpen
@onready var s_lid_close : AudioStreamPlayer3D = $LidClose
@onready var s_checkmark_show : AudioStreamPlayer3D = $CheckmarkShow
@onready var s_goal_complete_ding : AudioStreamPlayer3D = $GoalCompleteDing
@onready var s_piece_complete : AudioStreamPlayer3D = $PieceComplete
@onready var s_next_goal : AudioStreamPlayer3D = $NextGoal

# loop
@onready var s_dissolving_loop : AudioStreamPlayer3D = $DissolvingLoop
@onready var s_static_loop : AudioStreamPlayer3D = $StaticLoop



func _ready() -> void:
	GLGoalThresholdManagerBus.connect('play_sound', _handle_play_sound)

func _handle_play_sound(sound_type : String) : 
	
	match sound_type : 	
		'elevator_moving' :
			s_elevator_moving.play()
		'elevator_arrive' :
			s_elevator_arrive.play()
		'lid_open' :
			s_lid_open.play()
		'lid_close' :
			s_lid_close.play()
		'checkmark_show' :	
			s_checkmark_show.play()
		'goal_complete_ding' : 		
			s_goal_complete_ding.play()
		'piece_complete' : 	
			s_piece_complete.play()	
		'next_goal' :
			s_next_goal.play()
		'start_dissolve_loop':
			s_dissolving_loop.play()
			s_static_loop.play()
		'stop_dissolve_loop': 
			s_dissolving_loop.stop()
			s_static_loop.stop()
			
