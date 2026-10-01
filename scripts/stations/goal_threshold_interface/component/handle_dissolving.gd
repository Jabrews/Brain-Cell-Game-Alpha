extends Node

# components
@onready var dissolve_delay_timer: Timer = $DissolveDelayTimer
@onready var helper_dissolve_cell: Node = $"../HelperDissolveCell"
@onready var helper_refresh_displays: Node = $"../HelperRefreshDisplays"
@onready var handle_threshold_stat_finished: Node = $"../HandleThresholdStatFinished"

var valid_dissolving_stats: Array[DissolvingStat] = []


func _ready() -> void:
	dissolve_delay_timer.connect("timeout", _handle_dissolve_delay_timer_timeout)


func _refresh() -> void:
	
	var dissolving_cell: DissolvingCell = (
		helper_dissolve_cell.dissolving_cell
	)
	
	valid_dissolving_stats.clear()
	
	
	# no cell
	if dissolving_cell == null:
		dissolve_delay_timer.stop()
		helper_refresh_displays._refresh()
		return
	
	
	_rebuild_valid_dissolving_stats(
		dissolving_cell
	)
	
	
	if valid_dissolving_stats.is_empty():
		dissolve_delay_timer.stop()
	else:
		dissolve_delay_timer.start()
	
	
	helper_refresh_displays._refresh()


func _handle_dissolve_delay_timer_timeout() -> void:
	
	# IMPORTANT:
	# this is the cell this specific timer tick started with
	var dissolving_cell: DissolvingCell = (
		helper_dissolve_cell.dissolving_cell
	)
	
	
	if dissolving_cell == null:
		dissolve_delay_timer.stop()
		return
	
	
	# dissolve every valid stat by 1
	for dissolving_stat: DissolvingStat in valid_dissolving_stats:
		
		var threshold_stat: ThresholdStat = (
			dissolving_stat.corresponding_threshold_stat
		)
		
		
		# goal no longer accepts this stat
		if threshold_stat.disabled or threshold_stat.finished:
			continue
		
		
		# only defect remains
		if (
			dissolving_stat.amount_to_decrease
			<= dissolving_stat.defect_ignore
		):
			continue
		
		
		# decrease clean cell value
		dissolving_stat.amount_to_decrease -= 1.0
		
		
		# decrease goal
		threshold_stat.current_value -= 1.0
		
		threshold_stat.current_value = maxf(
			threshold_stat.current_value,
			0.0
		)
		
		
		# threshold stat finished
		if threshold_stat.current_value <= 0.0:
			
			threshold_stat.finished = true
			
			handle_threshold_stat_finished._handle()
			
			if helper_dissolve_cell.dissolving_cell != dissolving_cell:
				return
	
	
	# display final values from this tick
	helper_refresh_displays._refresh()
	
	
	# extra safety:
	# something else may have replaced the cell during this tick
	if helper_dissolve_cell.dissolving_cell != dissolving_cell:
		return
	
	
	# rebuild list using this cell's new values
	_rebuild_valid_dissolving_stats(
		dissolving_cell
	)
	
	
	# still dissolving
	if not valid_dissolving_stats.is_empty():
		return
	
	
	# this OLD/current cell is actually finished
	dissolve_delay_timer.stop()
	
	
	var collected_cell: BrainCell = (
		dissolving_cell.corresponding_cell
	)
	
	
	if collected_cell != null:
		GLCellManagerBus.collected_cell.emit_signal(
			"delete_selected_collected_cell",
			collected_cell
		)
	
	
	# only clear if this is STILL the same cell
	if helper_dissolve_cell.dissolving_cell == dissolving_cell:
		helper_dissolve_cell.dissolving_cell = null


func _rebuild_valid_dissolving_stats(
	dissolving_cell: DissolvingCell
) -> void:
	
	valid_dissolving_stats.clear()
	
	
	var dissolving_stats: Array[DissolvingStat] = [
		dissolving_cell.strength_dissolving_stat,
		dissolving_cell.intelligence_dissolving_stat,
		dissolving_cell.community_dissolving_stat,
	]
	
	
	for dissolving_stat: DissolvingStat in dissolving_stats:
		
		var threshold_stat: ThresholdStat = (
			dissolving_stat.corresponding_threshold_stat
		)
		
		
		if threshold_stat.disabled:
			continue
		
		
		if threshold_stat.finished:
			continue
		
		
		# no clean amount left
		if dissolving_stat.amount_to_decrease <= dissolving_stat.defect_ignore :
			continue
		
		
		valid_dissolving_stats.append(
			dissolving_stat
		)
