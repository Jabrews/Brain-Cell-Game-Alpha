extends Node

@onready var stat_bar_sprites : Array[Sprite2D] = [
	$"../Stats/Strength/StrengthBar",
	$"../Stats/Intelligence/IntelligenceBar",
	$"../Stats/Community/CommunityBar"
]
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

var stats : Array[String] = [
	"strength",
	"intelligence",
	"community"
]


func _display(
	strength_amount_to_decrease : int,
	intelligence_amount_to_decrease : int,
	community_amount_to_decrease : int
) -> void:
	
	for stat : String in stats:
		
		var max_value : int
		var left_stat_value : int
		var amount_to_decrease : int
		var stat_bar : Sprite2D
		var progress_circle : TextureRect
		var curr_value_label : Label
		
		match stat:
			"strength":
				max_value = GLGoalThresholdBus.active_goal_threshold.strength.max_stat_value
				left_stat_value = GLGoalThresholdBus.active_goal_threshold.strength.left_stat_value
				amount_to_decrease = strength_amount_to_decrease
				stat_bar = stat_bar_sprites[0]
				progress_circle = progress_circles[0]
				curr_value_label = curr_value_labels[0]
			
			"intelligence":
				max_value = GLGoalThresholdBus.active_goal_threshold.intelligence.max_stat_value
				left_stat_value = GLGoalThresholdBus.active_goal_threshold.intelligence.left_stat_value
				amount_to_decrease = intelligence_amount_to_decrease
				stat_bar = stat_bar_sprites[1]
				progress_circle = progress_circles[1]			
				curr_value_label = curr_value_labels[1]
			
			"community":
				max_value = GLGoalThresholdBus.active_goal_threshold.community.max_stat_value
				left_stat_value = GLGoalThresholdBus.active_goal_threshold.community.left_stat_value
				amount_to_decrease = community_amount_to_decrease
				stat_bar = stat_bar_sprites[2]
				progress_circle = progress_circles[2]			
				curr_value_label = curr_value_labels[2]
			
			_:
				push_error("bad stat: ", stat)
				continue
		
		curr_value_label.text = str(left_stat_value)
		
		# current red position
		var red_shader_value : float = (
			float(left_stat_value) /
			float(max_value)
		)
		
		stat_bar.material.set_shader_parameter(
			"red_value",
			red_shader_value
		)
		
		# set progress circle 
		progress_circle.material.set_shader_parameter(
			"progress",
			red_shader_value,
		)
		
		progress_circle._update_percant_label(max_value, left_stat_value)
		
		
		# remaining yellow distance
		var yellow_shader_value : float = (
			float(amount_to_decrease) /
			float(max_value)
		)
		
		stat_bar.material.set_shader_parameter(
			"yellow_value",
			yellow_shader_value
		)
		
