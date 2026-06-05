extends Node

# componnets
@onready var recduce_hidden_quanity : Node = $ReduceHiddenQuanitiy
@onready var plant_hidden_bombs : Node = $PlantHiddenBombs


func _handle_hidden(constructor : CellConstructor, new_prisoners : Array[BrainCell]) :
	
	var stats_to_hide = IVHiddenStats.stats_to_hide
	
	# exit early if no stats to hide
	if len(stats_to_hide) == 0 :
		return new_prisoners
	
	var max_stats_to_hide = IVHiddenStats.max_stats_to_hide
	
	# exit early if no stat hide quanity
	if max_stats_to_hide == 0 :
		return new_prisoners
	
	# reduce hidden quanity	using constructor
	max_stats_to_hide = recduce_hidden_quanity._handle_reduce_quanity(constructor.cell_quantity, max_stats_to_hide)
	# notice this looks extremly hacky
	# this is because we need to access this helper inside the prisoner profiler
	max_stats_to_hide = recduce_hidden_quanity._handle_reduce_disabled(
		constructor.strength.stat_enabled,
		constructor.intelligence.stat_enabled,	
		constructor.community.stat_enabled,
		max_stats_to_hide
	)	
	
	print('max stats to hide : ', max_stats_to_hide, ' from total : ', str(IVHiddenStats.max_stats_to_hide))

	# apply hidden stats randomly
	new_prisoners = randomly_apply_hidden_stats(new_prisoners, max_stats_to_hide)
	
	# plant bombs behinde hidden stats if possible
	var can_plant_hidden_bombs = plant_hidden_bombs._check_can_plant_bombs()
	if can_plant_hidden_bombs :
		new_prisoners = plant_hidden_bombs._plant_hidden_bombs(new_prisoners)

	return new_prisoners
	
func randomly_apply_hidden_stats(new_prisoners : Array[BrainCell], max_stats_to_hide : int) :

	var valid_targets = []

	# build list of all possible hidden stat targets
	for cell : BrainCell in new_prisoners:

		if cell.strength.enabled and not cell.strength.hidden:
			valid_targets.append({
				"cell": cell,
				"stat": "strength"
			})

		if cell.intelligence.enabled and not cell.intelligence.hidden:
			valid_targets.append({
				"cell": cell,
				"stat": "intelligence"
			})

		if cell.community.enabled and not cell.community.hidden:
			valid_targets.append({
				"cell": cell,
				"stat": "community"
			})

	# randomize order
	valid_targets.shuffle()

	# never try to hide more than exists
	var hide_count = mini(max_stats_to_hide, valid_targets.size())

	for i in hide_count:

		var target = valid_targets[i]
		var cell : BrainCell = target.cell

		match target.stat:

			"strength":
				cell.strength.hidden = true

			"intelligence":
				cell.intelligence.hidden = true

			"community":
				cell.community.hidden = true

	return new_prisoners
