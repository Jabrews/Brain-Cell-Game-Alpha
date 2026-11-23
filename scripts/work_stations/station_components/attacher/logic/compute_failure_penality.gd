extends Node

# components
@onready var parent_station_attacher : Node3D = $"../.."

var stats : Array[String] = ['strength', 'intelligence', 'community']

func _compute() :
	
	var loaded_cell : BrainCell = parent_station_attacher._get_loaded_cell()
	
	if not loaded_cell : 
		return
	
	for stat_type : String in stats : 
		
		var cell_stat : BrainCellStat = loaded_cell.get_stat(stat_type)
		var stat_jar_item : StatJarItem = GLAttacherComponentBus.main_stat_replacement_state[stat_type]		
		
		if not cell_stat : 	
			push_error('unable to find cell stat. for type : ', stat_type)
		
		# set penality based on if over-riding already disabled stat.
		if cell_stat.enabled and stat_jar_item : 			
			GLAttacherComponentBus.main_stat_replacement_failure_penality[stat_type] = true			
		else : 
			GLAttacherComponentBus.main_stat_replacement_failure_penality[stat_type] = false 
		
	# failure rate
	parent_station_attacher.failure_rate = 	GAMEFailureChance.attacher_helper._get_total_failure_chance(
		loaded_cell,	
		GLAttacherComponentBus.main_stat_replacement_failure_penality,
		GLAttacherComponentBus.main_stat_replacement_state,
	)
	
				
			
			
		
		
		
		
		
	
	
	
	
	
	
	
	
