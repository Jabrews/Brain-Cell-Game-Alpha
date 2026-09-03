extends Node

var possible_threshold_stats : Array = [
	[
	StatThreshold.new('strength', 'large', 400, 400),
	StatThreshold.new('intelligence', 'small', 200, 200),
	StatThreshold.new('community', 'medium', 300, 300),
	],
]



func _create_goal(): 
	
	var threshold_stats = possible_threshold_stats.pick_random()
	
	var new_goal_threshold : ThresholdGoal = ThresholdGoal.new(
		threshold_stats[0], # strength
		threshold_stats[1], # intell. 
		threshold_stats[2], # community
	)
	
	GLGoalThresholdBus.active_goal_threshold = new_goal_threshold
	
	GLGoalThresholdBus.emit_signal('created_goal_threshold', new_goal_threshold)
	
	
