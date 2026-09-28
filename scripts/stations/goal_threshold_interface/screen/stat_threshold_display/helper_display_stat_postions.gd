extends Node

# textures
@onready var t_small_bar : Texture = preload("res://models/goal_threshold/BarSmall.png")
@onready var t_medium_bar : Texture = preload("res://models/goal_threshold/BarMedium.png")
@onready var t_large_bar : Texture = preload("res://models/goal_threshold/BarLarge.png")

# bar pos
const SMALL_BAR_POS_X :  float = 352.0
const MEDIUM_BAR_POS_X :  float = 376.0
const LARGE_BAR_POS_X :  float = 400.5


# label x pos
const SMALL_BAR_LABEL_SIZE_X : float = 335.0
const MEDIUM_BAR_LABEL_SIZE_X : float = 383.0
const LARGE_BAR_LABEL_SIZE_X : float = 432.0


func _display(dissolved_stat : DissolveStat, bar : Sprite2D, threshold_value_left_label : Label) :
	
	# set these
	var bar_texture : Texture
	var bar_x_pos : float
	var label_x_size : float
	
	var threshold_stat_size : String = dissolved_stat.corresponding_threshold_stat.size
	
	match threshold_stat_size: 
		'small' :
			bar_texture = t_small_bar
			bar_x_pos = SMALL_BAR_POS_X
			label_x_size = SMALL_BAR_LABEL_SIZE_X
		'medium' :
			bar_texture = t_medium_bar
			bar_x_pos = MEDIUM_BAR_POS_X
			label_x_size = MEDIUM_BAR_LABEL_SIZE_X
		'large' : 
			bar_texture = t_large_bar
			bar_x_pos = LARGE_BAR_POS_X
			label_x_size = LARGE_BAR_LABEL_SIZE_X
	
	bar.texture = bar_texture
	bar.position.x = bar_x_pos
	threshold_value_left_label.size.x = label_x_size
		
	
	
	
		
