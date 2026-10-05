extends Node

@onready var t_small_bar : Texture = preload("res://models/goal_threshold/bars_accept_cell/BarSmall.png")
@onready var t_medium_bar : Texture = preload("res://models/goal_threshold/bars_accept_cell/BarMedium.png")
@onready var t_large_bar : Texture = preload("res://models/goal_threshold/bars_accept_cell/BarLarge.png")

# bar positions
const SMALL_BAR_POS_X: float = 276.0
const MEDIUM_BAR_POS_X: float = 277.0
const LARGE_BAR_POS_X: float = 288.0


func _display( threshold_stat : ThresholdStat, bar : Sprite2D) -> void:
	
	match threshold_stat.size :
		
		'small' :		
			bar.texture = t_small_bar
			bar.position.x = SMALL_BAR_POS_X
		
		'medium' :
			bar.texture = t_medium_bar 
			bar.position.x = MEDIUM_BAR_POS_X
		
		'large' : 
			bar.texture = t_large_bar
			bar.position.x = LARGE_BAR_POS_X
		
	
