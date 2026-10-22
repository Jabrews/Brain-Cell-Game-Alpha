extends Node

@export_enum("Round 1", "Round 3") var round_profile: int = 0


func _create(prisoner_card: PrisonerOfferCard) -> BrainCell:
	var max_stat_value: float = IVCellCreator.max_stat_value
	if max_stat_value <= 0.0:
		push_error("max_stat_value must be greater than 0.")
		return null

	var strength := _create_stat(
		"strength", prisoner_card.strength,
		prisoner_card.total_defect_rate, max_stat_value
	)
	var intelligence := _create_stat(
		"intelligence", prisoner_card.intelligence,
		prisoner_card.total_defect_rate, max_stat_value
	)
	var community := _create_stat(
		"community", prisoner_card.community,
		prisoner_card.total_defect_rate, max_stat_value
	)

	return BrainCell.new(
		GAMENameManager.pick_prisoner_names(),
		[],
		strength,
		intelligence,
		community,
		prisoner_card.average_lifespan
	)


func _create_stat(
	stat_type: String,
	card_stat: PrisonerCardStat,
	total_defect_rate: float,
	max_stat_value: float
) -> BrainCellStat:
	# Keep a disabled stat object because BrainCell expects all three stats.
	if card_stat == null or not card_stat.enabled:
		return BrainCellStat.new(stat_type, false, 0.0, 0.0, false)

	var low_value: float = minf(card_stat.min_value, card_stat.max_value)
	var high_value: float = maxf(card_stat.min_value, card_stat.max_value)
	var clean_value: float = clampf(
		randf_range(low_value, high_value),
		0.0,
		max_stat_value
	)

	var stat_defect_rate: float = clampf(card_stat.defect_rate, 0.0, 100.0)
	var defect_value: float
	
	# DEBUG ADMIN STUFF	
	var defect_gen_case : String = ''

	# The stat's own rate determines the chance of an under-value defect.
	if randf() >= stat_defect_rate / 100.0:
		
		# ZERO DEFECT RATE LOW
		if stat_defect_rate == 0.0 : 
			defect_value = _generate_zero_defect(clean_value)
			if GLGameManagerBus.debug_prisoner_showcase_show_stat_data : 		
				defect_gen_case = 'zero'
		# OTEHR DEFECT RATE LOW
		else :
			defect_value = _generate_under_defect(clean_value, stat_defect_rate)
			
			if GLGameManagerBus.debug_prisoner_showcase_show_stat_data : 		
				defect_gen_case = 'under'
			
	else:
		var weights := _get_equal_above_weights(total_defect_rate)

		if randf() < weights.x:
			defect_value = _generate_equal_defect(clean_value)
			
			if GLGameManagerBus.debug_prisoner_showcase_show_stat_data : 		
				defect_gen_case = 'equal'		
			
		else:
			defect_value = _generate_above_defect(clean_value, max_stat_value)
			
			if GLGameManagerBus.debug_prisoner_showcase_show_stat_data : 		
				defect_gen_case = 'above'		
			

	var admin_data : Dictionary = {}

	if GLGameManagerBus.debug_prisoner_showcase_show_stat_data : 
		admin_data = {'defect_gen_case' : defect_gen_case}


	# round defect and clean
	clean_value = snapped(clean_value, 0.1)
	defect_value = snapped(defect_value, 0.1)

	return BrainCellStat.new(
		stat_type,
		true,
		clean_value,
		defect_value,
		false,
		admin_data
	)


# Vector2.x is equal weight; Vector2.y is above weight.
func _get_equal_above_weights(total_defect_rate: float) -> Vector2:
	var rate := clampf(total_defect_rate, 0.0, 100.0)

	if round_profile == 0:
		if rate < 50.0:
			return Vector2(0.9, 0.1)
		elif rate < 75.0:
			return Vector2(0.7, 0.3)
		else:
			return Vector2(0.5, 0.5)
	else:
		if rate < 50.0:
			return Vector2(0.8, 0.2)
		elif rate < 75.0:
			return Vector2(0.6, 0.4)
		else:
			return Vector2(0.4, 0.6)


func _generate_zero_defect(_clean_value : float) -> float : 
	
# get defect value using ranges
	var defect_value : float = randf_range(0.0, IVCellCreator.max_stat_value * 0.10)
	
	return snappedf(defect_value, 0.1)
	
	


func _generate_under_defect(clean_value: float, stat_defect_rate : float) -> float:
	
	# min value should be adapated to defect rate.
	# this is a HACK solution but... IDC
	var min_value : float = 0.0 + IVDefaultPrisonerCreate.under_defect_stat_defect_min_increase * stat_defect_rate
	
	# get max value. always 25% less than clean value
	var max_value : float = clean_value * 0.75 
	
	# get defect value using ranges
	var defect_value : float = randf_range(min_value, max_value)
	
	return snappedf(defect_value, 0.1)
	
	


func _generate_equal_defect(clean_value: float) -> float:
	var variation: float = randf_range(-0.10, 0.10)
	return clean_value * (1.0 + variation)


func _generate_above_defect(
	clean_value: float,
	max_stat_value: float
) -> float:
	var increase: float = randf_range(0.25, 0.50)
	return minf(clean_value * (1.0 + increase), max_stat_value)
