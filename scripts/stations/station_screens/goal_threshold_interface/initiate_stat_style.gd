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
@onready var curr_value_labels : Array[Label] = [
	$"../Stats/Strength/CurrTresholdValueLeft",
	$"../Stats/Intelligence/CurrTresholdValueLeft",
	$"../Stats/Community/CurrTresholdValueLeft"
]


# stat bar textures
@onready var small_bar_texture : Texture = preload("res://models/goal_threshold/BarSmall.png")
@onready var medium_bar_texture : Texture = preload("res://models/goal_threshold/BarMedium.png")
@onready var large_bar_texture : Texture = preload("res://models/goal_threshold/BarLarge.png")

# stat bar postion
var small_bar_pos_x : float = 299.0
var medium_bar_pos_x : float = 316.0
var large_bar_pos_x : float = 330.0

# curr value label pos
var small_cur_label_pos_x : float = 145.0
var medium_cur_label_pos_x : float = 162.0
var large_cur_label_pos_x : float = 174.0




func _ready() -> void:
	
	small_bar_pos_x = stat_bars[2].position.x
	medium_bar_pos_x = stat_bars[1].position.x
	large_bar_pos_x = stat_bars[0].position.x
	
	for stat_bar : Sprite2D in stat_bars : 
		stat_bar.material = stat_bar.material.duplicate()
		stat_bar.material.set_shader_parameter("red_value", 1.0)
		stat_bar.material.set_shader_parameter("yellow_value", 0.0)
	for progress_circle : TextureRect in progress_circles : 
		progress_circle.material = progress_circle.material.duplicate()
		progress_circle.material.set_shader_parameter("progress", 0.0)
	


func _initiate(goal_threshold : ThresholdGoal): 
	
	# get an array of stat goals
	var threshold_stats : Array[StatThreshold] = []
	threshold_stats.append(goal_threshold.strength)
	threshold_stats.append(goal_threshold.intelligence)
	threshold_stats.append(goal_threshold.community)
	
	for threshold_stat : StatThreshold in threshold_stats :
		
		var selected_stat_bar : Sprite2D
		var curr_label : Label
		var max_stat_value : int
		
		match threshold_stat.stat_type :		
			'strength' :
				selected_stat_bar = stat_bars[0]
				curr_label = curr_value_labels[0]
				max_stat_value = GLGoalThresholdBus.active_goal_threshold.strength.max_stat_value
			'intelligence' :
				selected_stat_bar = stat_bars[1]		
				curr_label = curr_value_labels[1]
				max_stat_value = GLGoalThresholdBus.active_goal_threshold.intelligence.max_stat_value
			'community' :
				selected_stat_bar = stat_bars[2]
				curr_label = curr_value_labels[2]			
				max_stat_value = GLGoalThresholdBus.active_goal_threshold.community.max_stat_value			
			_ : 
				push_error('bad stat found : ', threshold_stat.stat_type)
				selected_stat_bar = stat_bars[0]
		
		match threshold_stat.bar_size: 		
			'small' :
				selected_stat_bar.texture = small_bar_texture
				selected_stat_bar.position.x = small_bar_pos_x
				curr_label.position.x = small_cur_label_pos_x

			'medium' :
				selected_stat_bar.texture = medium_bar_texture 
				selected_stat_bar.position.x = medium_bar_pos_x
				curr_label.position.x = medium_cur_label_pos_x 
			'large' :
				selected_stat_bar.texture = large_bar_texture 
				selected_stat_bar.position.x = large_bar_pos_x
				curr_label.position.x = large_cur_label_pos_x 
			_ : 
				push_error('bad stat size found : ', threshold_stat.stat_type)
				selected_stat_bar.texture = large_bar_texture 
		
		curr_label.text = str(max_stat_value)
		
		
		
		
				
		
		
		
		
		
		
		
		
		
	
	
	
	
	
	
	
	
