extends Node

var possible_threshold_stats : Array = [
	[
	ThresholdStat.new('strength', 400, 'large'),
	ThresholdStat.new('intelligence', 200, 'small'),
	ThresholdStat.new('community', 300, 'medium'),
	],
]



func _create_goal(): 
	
	var threshold_stats = possible_threshold_stats.pick_random()
	
	var new_goal_threshold : GoalThreshold = GoalThreshold.new(
		threshold_stats[0], # strength
		threshold_stats[1], # intell. 
		threshold_stats[2], # community
	)
	
	GLGoalThresholdBus.active_goal_threshold = new_goal_threshold
	
	GLGoalThresholdBus.emit_signal('created_goal_threshold', new_goal_threshold)
	
	
