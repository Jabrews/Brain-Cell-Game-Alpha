extends Node

var possible_1 : GoalThreshold = GoalThreshold.new(
	1,#  starting active piece
	{
		1: ThresholdPiece.new(
			4,   # total turns
			25,  # early completion energy reward
			2,   # early completion turn limit
			false,
			ThresholdStat.new("large", 400, false),   # strength
			ThresholdStat.new("small", 100, false),   # intelligence
			ThresholdStat.new("medium", 250, false)   # community
		),
		
		2: ThresholdPiece.new(
			5,
			30,
			2,
			false,		
			ThresholdStat.new("medium", 250, false),
			ThresholdStat.new("large", 400, false),
			ThresholdStat.new("small", 100, false)
		),
		
		3: ThresholdPiece.new(
			5,
			35,
			3,
			false,		
			ThresholdStat.new("small", 100, false),
			ThresholdStat.new("medium", 250, false),
			ThresholdStat.new("large", 400, false)
		),
		4: ThresholdPiece.new(
			6,
			40,
			3,
			false,		
			ThresholdStat.new("large", 450, false),
			ThresholdStat.new("medium", 300, false),
			ThresholdStat.new("large", 400, false)
		)
	},
)

func _create_goal(): 
	
	GLGoalThresholdManagerBus.active_goal_threshold = possible_1 
	
	GLGoalThresholdManagerBus.emit_signal('created_goal_threshold',  possible_1)
	
	
