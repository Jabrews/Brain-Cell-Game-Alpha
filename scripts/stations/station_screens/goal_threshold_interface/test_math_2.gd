extends Node

@onready var stat_bars: Array[Sprite2D] = [
	$"../Stats/Strength/StrengthBar",
	$"../Stats/Intelligence/IntelligenceBar",
	$"../Stats/Community/CommunityBar"
]
@onready var progress_circles : Array[TextureRect] = [
	$"../Stats/Strength/ProgressCircle",
	$"../Stats/Intelligence/ProgressCircle",
	$"../Stats/Community/ProgressCircle"
]

## NOTE
# this functionality prototype showcases how 
# we can decrease a bar to a set number and shaders update
# (can even be edited - see process)


@onready var increment_down_timer : Timer = $IncrementDownTimer
@export var strength_decrease_amount : int = 200
@export var intelligence_decrease_amount : int = 100
@export var community_decrease_amount : int = 150
var max_strength_value : int
var max_intelligence_value : int
var max_community_value : int

var stats : Array[String] = [
	"strength",
	"intelligence",
	"community"
]

func _ready() -> void:
	increment_down_timer.connect("timeout", _handle_increment_down_timer)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :
		community_decrease_amount += 10
	#if Input.is_action_just_pressed('debug2') :
		#community_decrease_amount = 0


func _start(goal_threshold : ThresholdGoal) -> void:
	max_strength_value = goal_threshold.strength.max_stat_value
	max_intelligence_value = goal_threshold.intelligence.max_stat_value
	max_community_value = goal_threshold.community.max_stat_value
	
	increment_down_timer.start()


func _handle_increment_down_timer() -> void:
	
	var all_stats_finished : bool = true
	
	for stat in stats:
		
		var current_value : int
		var current_max_value : int
		var decrease_amount : int
		var stat_bar : Sprite2D
		var progress_circle : TextureRect 
		
		match stat:
			"strength":
				current_max_value = max_strength_value
				current_value = GLGoalThresholdBus.active_goal_threshold.strength.left_stat_value
				decrease_amount = strength_decrease_amount
				stat_bar = stat_bars[0]
				progress_circle = progress_circles[0]
				
			"intelligence":
				current_max_value = max_intelligence_value
				current_value = GLGoalThresholdBus.active_goal_threshold.intelligence.left_stat_value
				decrease_amount = intelligence_decrease_amount
				stat_bar = stat_bars[1]
				progress_circle = progress_circles[1]
				
			"community":
				current_max_value = max_community_value
				current_value = GLGoalThresholdBus.active_goal_threshold.community.left_stat_value
				decrease_amount = community_decrease_amount
				stat_bar = stat_bars[2]
				progress_circle = progress_circles[2]
				
			_:
				push_error("problem")
				continue
		
		
		# final integer value this stat should decrease to
		var decrease_to_value : int = current_max_value - decrease_amount
		

		## calls everytime we finished to decrease value
		if current_value <= decrease_to_value:
			stat_bar.material.set_shader_parameter("yellow_value", 0.0)
			
			progress_circle._toggle_progress_active(false)
			
			
			#print(stat, " finished decreasing")
			continue
		
		
		# -------------------------
		# DECREASE STAT
		# -------------------------
		
		if current_value > decrease_to_value:
			
			progress_circle._toggle_progress_active(true)
			
			all_stats_finished = false
			
			current_value -= 5
			
			# prevent going below target
			current_value = maxi(
				current_value,
				decrease_to_value
			)
			
			
			
			# update real threshold value
			match stat:
				"strength":
					GLGoalThresholdBus.active_goal_threshold.strength.left_stat_value= current_value
					
				"intelligence":
					GLGoalThresholdBus.active_goal_threshold.intelligence.left_stat_value = current_value
					
				"community":
					GLGoalThresholdBus.active_goal_threshold.community.left_stat_value = current_value
					
				_:
					push_error("problem")
		
		
		# -------------------------
		# RED SHADER VALUE
		# only floats here
		# -------------------------
		
		var red_shader_value : float = (
			float(current_value) /
			float(current_max_value)
		)
		
		stat_bar.material.set_shader_parameter(
			"red_value",
			red_shader_value
		)
		#  also set progress cirlcle
		progress_circle.material.set_shader_parameter(
			"progress",
			red_shader_value,
		)
		progress_circle._update_percant_label(current_max_value, current_value)
		
		
		# -------------------------
		# YELLOW SHADER VALUE
		# actual math stays integer
		# -------------------------
		
		var remaining_decrease : int = (
			current_value -
			decrease_to_value
		)
		
		var yellow_shader_value : float = (
			float(remaining_decrease) /
			float(current_max_value)
		)
		
		stat_bar.material.set_shader_parameter(
			"yellow_value",
			yellow_shader_value
		)
		
		
	
	if all_stats_finished:
		increment_down_timer.stop()
