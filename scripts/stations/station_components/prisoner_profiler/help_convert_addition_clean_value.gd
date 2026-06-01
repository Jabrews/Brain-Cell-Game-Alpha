extends Node

var clean_ranges = {
	1: "low",
	2: "low-mid",
	3: "middle",
	4: "high-mid",
	5: "high"
}


func _handle_help_convert_addition_value(
	clean_range : String,
	stat_addition : int
) -> float:

	var increment = IVCellCreator.max_stat_value / 20.0

	var range_values = {
		"low": increment * 0,
		"low-mid": increment * 5,
		"middle": increment * 10,
		"high-mid": increment * 15,
		"high": increment * 20
	}

	# keep within 1-5
	stat_addition = clampi(stat_addition, 1, 5)

	# high range is always max
	if clean_range == "high":
		return 0

	if not range_values.has(clean_range):
		push_error("invalid clean range")
		return 0

	# each clean range spans 5 increments
	var addition_value = (stat_addition - 1) * increment

	addition_value = min(
		addition_value,
		IVCellCreator.max_stat_value
	)

	return round(addition_value * 10.0) / 10.0
