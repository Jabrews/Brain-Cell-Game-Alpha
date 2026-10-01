extends Node


# components
@onready var dissolve_delay_timer : Timer = $DissolveDelayTimer
@onready var helper_dissolve_stats : Node = $"../HelperDissolveStats"
@onready var helper_refresh_displays : Node = $"../HelperRefreshDisplays"
@onready var handle_detect_finshed : Node = $"../HelperDetectFinished"
@onready var parent_station : Node3D = $".."

var valid_dissolving_stats : Array[DissolveStat] = []


func _ready() -> void:
	dissolve_delay_timer.connect(
		"timeout",
		_handle_dissolve_delay_timer
	)


func _refresh() -> void:
	
	var dissolving_stats : Array[DissolveStat] = (
		helper_dissolve_stats._get_dissolving_stats()
	)
	
	# empty array
	valid_dissolving_stats.clear()
	
	# find every stat that still has something to dissolve
	for dissolving_stat : DissolveStat in dissolving_stats:
		
		if dissolving_stat.amount_to_decrease > 0.0:
			
			# make sure its not disabled before adding to valud
			if not dissolving_stat.corresponding_threshold_stat.disabled : 			
				valid_dissolving_stats.append(dissolving_stat)
	
	
	# run timer while at least one stat is dissolving
	if not valid_dissolving_stats.is_empty():
		
		if dissolve_delay_timer.is_stopped():
			dissolve_delay_timer.start()
	
	else:
		dissolve_delay_timer.stop()
	
	
	helper_refresh_displays._refresh()


func _handle_dissolve_delay_timer() -> void:
	
	# process each currently dissolving stat
	for dissolving_stat : DissolveStat in valid_dissolving_stats:
		
		if dissolving_stat.amount_to_decrease <= 0.0:
			continue
		
		var threshold_stat : ThresholdStat = (
			dissolving_stat.corresponding_threshold_stat
		)
		
		# dissolve 1 point
		dissolving_stat.amount_to_decrease -= 1.0
		
		# increase progress toward goal by lowering remaining value
		threshold_stat.current_value -= 1.0
		
		
		# prevent values going below 0
		dissolving_stat.amount_to_decrease = maxf(
			dissolving_stat.amount_to_decrease,
			0.0
		)
		
		threshold_stat.current_value = maxf(
			threshold_stat.current_value,
			0.0
		)
		
		
		## stat completed
		if threshold_stat.current_value <= 0.0:
			threshold_stat.finished = true
			
			# let parent station know
			parent_station._handle_threshold_stat_finished()
			
	
	
	# remove stats that finished dissolving
	for i : int in range(valid_dissolving_stats.size() - 1, -1, -1):
		
		if valid_dissolving_stats[i].amount_to_decrease <= 0.0:
			valid_dissolving_stats.remove_at(i)
	
	
	# nothing left dissolving
	if valid_dissolving_stats.is_empty():
		dissolve_delay_timer.stop()
		return
	
	helper_refresh_displays._refresh()
