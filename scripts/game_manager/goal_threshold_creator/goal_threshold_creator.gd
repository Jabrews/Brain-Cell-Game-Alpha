extends Node

var possible_1 : GoalThreshold = GoalThreshold.new(
	1,#  starting active piece
	{
		1: ThresholdPiece.new(
			4,   # total turns
			25,  # early completion energy reward
			2,   # early completion turn limit
			false,
			ThresholdStat.new("small", 100, 100, false, false),   # strength
			ThresholdStat.new("small", 100, 100, false, false),   # intelligence
			ThresholdStat.new("medium", 0, 0, true, false)   # community
		),
		
		2: ThresholdPiece.new(
			5,
			30,
			2,
			false,		
			ThresholdStat.new("large", 400, 400, false, false),   # strength
			ThresholdStat.new("small", 100, 100, false, false),   # intelligence
			ThresholdStat.new("medium", 0, 0, true, false)   # community
		),
		
		3: ThresholdPiece.new(
			5,
			35,
			3,
			false,		
			ThresholdStat.new("large", 400, 400, false, false),   # strength
			ThresholdStat.new("small", 100, 100, false, false),   # intelligence
			ThresholdStat.new("medium", 0, 0, true, false)   # community
		),
		4: ThresholdPiece.new(
			6,
			40,
			3,
			false,		
			ThresholdStat.new("large", 400, 400, false, false),   # strength
			ThresholdStat.new("small", 100, 100, false, false),   # intelligence
			ThresholdStat.new("medium", 0, 0, true, false)   # community
		)
	},
)

func _create_goal(): 
	
	GLGoalThresholdManagerBus.active_goal_threshold = possible_1 
	
	GLGoalThresholdManagerBus.emit_signal('created_goal_threshold',  possible_1)
	
	
