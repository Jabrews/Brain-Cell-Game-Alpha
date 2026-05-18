extends Node

func _create(cell_index : int, constructor : CellConstructor, clean_stats : Array[float]) -> Array[float] :
	
	### DEFECT STATS ###
		# decide defect range for this cell
		var current_defect_range : String
		# split defect ranges across cells
		if constructor.defect_ranges.size() > 1:
			# clamp index so it never exceeds array size
			var defect_index = min(
				cell_index,
				constructor.defect_ranges.size() - 1
			)
			current_defect_range = constructor.defect_ranges[defect_index]
		else:
			current_defect_range = constructor.defect_ranges[0]
		# finally create efect stats
		var defect_stats : Array[float] = create_defect_stats(clean_stats, current_defect_range)
		
		return defect_stats


func create_defect_stats(clean_stats : Array[float], defect_range : String) -> Array[float]:

	var defect_stats : Array[float] = []

	# find highest clean stat
	var highest_clean_stat : float = clean_stats.max()

	for clean_stat in clean_stats:

		var defect_value : float = 0.0

		match defect_range:

			'0':
				defect_value = 0

			'low':
				# highest stat gets stronger defect
				if clean_stat == highest_clean_stat:
					defect_value = clean_stat * 0.40
				else:
					defect_value = clean_stat * 0.25

			'equal':
				defect_value = clean_stat

			'high':
				if clean_stat == highest_clean_stat:
					defect_value = clean_stat * 1.30
				else:
					defect_value = clean_stat * 1.20

			_:
				push_error("invalid defect range")

		# round to 0.0 decimal
		defect_value = round(defect_value * 10.0) / 10.0

		defect_stats.append(defect_value)

	return defect_stats
