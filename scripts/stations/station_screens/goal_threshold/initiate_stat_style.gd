extends Node

# stat bar sprites
@onready var stat_bars : Array[Sprite2D] = [
	$"../Stats/Strength/StrengthBar",
	$"../Stats/Intelligence/IntelligenceBar",
	$"../Stats/Community/CommunityBar"
]
# progress circle texture rect
@onready var progress_circles : Array[TextureRect] = [
	$"../Stats/Strength/ProgressCircle",
	$"../Stats/Intelligence/ProgressCircle",
	$"../Stats/Community/ProgressCircle"
]
# stat bar textures
@onready var small_bar_texture : Texture = preload("res://models/goal_threshold/BarSmall.png")
@onready var medium_bar_texture : Texture = preload("res://models/goal_threshold/BarMedium.png")
@onready var large_bar_texture : Texture = preload("res://models/goal_threshold/BarLarge.png")

# stat bar postion
var small_bar_pos_x : float = 266.0
var medium_bar_pos_x : float = 315.0
var large_bar_pos_x : float = 352.0




func _ready() -> void:
	for stat_bar : Sprite2D in stat_bars : 
		stat_bar.material = stat_bar.material.duplicate()
		stat_bar.material.set_shader_parameter("red_value", 1.0)
		stat_bar.material.set_shader_parameter("yellow_value", 0.0)
	


func _initiate(goal_threshold : GoalThreshold): 
	
	# get an array of stat goals
	var threshold_stats : Array[ThresholdStat] = []
	threshold_stats.append(goal_threshold.strength)
	threshold_stats.append(goal_threshold.intelligence)
	threshold_stats.append(goal_threshold.community)
	
	for threshold_stat : ThresholdStat in threshold_stats :
		
		var selected_stat_bar : Sprite2D
		
		match threshold_stat.stat_type :		
			'strength' :
				selected_stat_bar = stat_bars[0]
			'intelligence' :
				selected_stat_bar = stat_bars[1]		
			'community' :
				selected_stat_bar = stat_bars[2]
			_ : 
				push_error('bad stat found : ', threshold_stat.stat_type)
				selected_stat_bar = stat_bars[0]
		
		match threshold_stat.stat_size : 		
			'small' :
				selected_stat_bar.texture = small_bar_texture
				selected_stat_bar.position.x = small_bar_pos_x
			'medium' :
				selected_stat_bar.texture = medium_bar_texture 
				selected_stat_bar.position.x = medium_bar_pos_x
			'large' :
				selected_stat_bar.texture = large_bar_texture 
				selected_stat_bar.position.x = large_bar_pos_x
			_ : 
				push_error('bad stat size found : ', threshold_stat.stat_type)
				selected_stat_bar.texture = large_bar_texture 
		
		
		
		
				
		
		
		
		
		
		
		
		
		
	
	
	
	
	
	
	
	
