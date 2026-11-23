extends Node

# componnets
@onready var goal_complete_parent : Control = $"../GoalComplete"
@onready var loading_next_piece_parent : Control = $"../LoadingNextPiece"
@onready var pieces_out_max_label : Label = $"../LoadingNextPiece/PiecesOutMaxLabel"


func _display(goal_threshold : GoalThreshold) :
	
	goal_complete_parent.visible = true
	
	await get_tree().create_timer(1.0).timeout
	
	goal_complete_parent.visible = false 
	
	pieces_out_max_label.text = str(goal_threshold.active_piece_index) + '/4'
	
	loading_next_piece_parent.visible = true	
	
	await get_tree().create_timer(2.5).timeout
	
	GLGoalThresholdManagerBus.emit_signal('play_sound', 'next_goal')
	
	loading_next_piece_parent.visible = false 
	
	
	
	
	
