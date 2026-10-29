extends Node

# components
@onready var parent_ideal_stat_creator : Node = $"../.."
@onready var energy_manager : Node = $"../../EnergyManager"



func _handle() :
	
	if not parent_ideal_stat_creator.enabled : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	
	## 1. see if all ideal stats are dissabled	
	
	var ideal_stats : Array[IdealStat] = parent_ideal_stat_creator.get_ideal_stats()
	
	var all_stats_dissabled : bool = true
	
	for ideal_stat in ideal_stats : 
		if ideal_stat.enabled == true : 
			all_stats_dissabled = false
			continue
	
	if all_stats_dissabled : 
		GLPrisonerProfilerComponentsBus.emit_signal('display_feedback', 'all_stats_disabled', {})		
		return
	
	## 2. see if player has exceeded maximum energy
	var total_energy : int = parent_ideal_stat_creator.total_energy
	var total_energy_spent : int = energy_manager._get_total_energy_spent()
	
	if total_energy + total_energy_spent < 0 : 
		GLPrisonerProfilerComponentsBus.emit_signal('display_feedback', 'exceeded_energy', {})		
		return
	
	## 3. see if any ideal stat is passed its lock
	# NOTE : normal case should be fixed. but keeping error case isnt bad idea
	
	var stats_in_lock_range : Array[String]	= []
	
	for ideal_stat in ideal_stats : 
		
		var stat_type = ideal_stat.stat_type
		
		if ideal_stat.value > ideal_stat.lock_max_value : 
			stats_in_lock_range.append(stat_type)
		
	if len(stats_in_lock_range) > 0 : 
		GLPrisonerProfilerComponentsBus.emit_signal('display_feedback', 'lock_warning', {'stats_in_lock_range' : stats_in_lock_range})		
		return
	
	## 4. CONFIRM OKAY
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
	parent_ideal_stat_creator._handle_ideal_stats_creation_finished()
		
		
		
		
		
		
		
		
		
		
	
