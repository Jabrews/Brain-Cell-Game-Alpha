extends Node

class_name DecreaseCleanStatCase


func decrease_clean_stat_case(
	stat_high: float,
	stat_low: float,
	target_stat: float
) -> float:
	
	
	return stat_high - (stat_low * 2)
	
	# This case only makes sense if the high stat is above the target.
	if stat_high <= target_stat:
		return round_stat(stat_high)
	
	# If low stat is not lower, it cannot help decrease.
	if stat_low >= stat_high:
		return round_stat(stat_high)
	
	var full_decrease_value: float = stat_low
	
	var distance_from_high_to_target: float = stat_high - target_stat
	var decrease_amount: float = stat_high - full_decrease_value
	
	if distance_from_high_to_target <= 0.0:
		return round_stat(stat_high)
	
	# 0.0 = no progress toward target
	# 0.5 = halfway toward target
	# 1.0 = exactly reaches target
	# >1.0 = goes below target
	var decrease_percent: float = decrease_amount / distance_from_high_to_target
	
	var curr_energy: float = GLGameManagerBus.curr_energy
	var max_energy: float = GLGameManagerBus.max_energy
	var half_energy: float = max_energy * 0.5
	
	var new_stat_value: float = stat_high
	
	# If full decrease would put us close enough to target, snap to target.
	if abs(full_decrease_value - target_stat) <= 20.0:
		new_stat_value = target_stat
	
	# Low progress toward target.
	elif decrease_percent <= 0.5:
		if curr_energy >= half_energy:
			new_stat_value = stat_high - (decrease_amount * IVCellBreeding.low_subtract_percant_scale)
		else:
			new_stat_value = stat_high - decrease_amount
	
	# Good progress toward target.
	elif decrease_percent > 0.5 and decrease_percent <= 1.0:
		if curr_energy >= half_energy:
			new_stat_value = stat_high - (decrease_amount * IVCellBreeding.high_subtract_percant_scale)
		else:
			new_stat_value = stat_high - decrease_amount
	
	# Would go below target. Clamp to target.
	else:
		new_stat_value = target_stat
	
	new_stat_value = clamp(new_stat_value, 0.0, IVCellCreator.max_stat_value)
	
	return round_stat(new_stat_value)


func round_stat(value: float) -> float:
	return round(value * 10.0) / 10.0
