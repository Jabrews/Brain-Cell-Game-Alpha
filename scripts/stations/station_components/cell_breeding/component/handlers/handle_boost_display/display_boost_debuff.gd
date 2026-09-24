extends Node

# components
@onready var get_side_boost_components : Node = $"../../GetSideBoostComponents"

var stats : Array[String] = ['strength', 'intelligence', 'community']

func _display(side : String, selected_stat : String, cell : BrainCell) :
	
	var boost_components : Dictionary = get_side_boost_components._get_boost_stat(side)
	
	var clean_bars : Array = boost_components["clean_bars"]
	var defect_bars : Array = boost_components["defect_bars"]
	
	
	var stat_index = stats.find(selected_stat)
	
	var clean_bar : Sprite2D = clean_bars[stat_index]
	var defect_bar : Sprite2D = defect_bars[stat_index]
	
	# get befroe	
	var before_debuff_stat : BrainCellStat = cell.get_stat(selected_stat)
	
	# get after debuff stat
	var after_debuff_stat: BrainCellStat = GAMECellBreeder.reduced_cell_charge_stat_helper._get_reduced(selected_stat, cell)
	
	var max_value : float = IVCellCreator.max_stat_value
	
	# set clean stat value
	clean_bar.material.set_shader_parameter("old_prisoner_value", before_debuff_stat.value / max_value)
	clean_bar.material.set_shader_parameter("new_prisoner_value", after_debuff_stat.value / max_value)
	
	# set defect stat value
	defect_bar.material.set_shader_parameter("prior_defect_value", before_debuff_stat.defect / max_value)
	defect_bar.material.set_shader_parameter("new_defect_value", after_debuff_stat.defect / max_value)
	
	## handle death chance skull
	
	var death_active = GAMECellBreeder.reduced_cell_charge_stat_helper._check_death(selected_stat, cell)
	
	if death_active :	
		
		var death_alert_sprites : Array[Sprite2D] = boost_components['death_alert_sprites']
		
		var death_alert_sprite : Sprite2D = death_alert_sprites[stat_index]
		
		death_alert_sprite._toggle_skull(true)
		
		GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'skull_warning')
	
	

func _reset(side : String, cell : BrainCell) :
	
	var boost_components : Dictionary = get_side_boost_components._get_boost_stat(side)
	
	var clean_bars : Array = boost_components["clean_bars"]
	var defect_bars : Array = boost_components["defect_bars"]
	var death_alert_sprites : Array = boost_components['death_alert_sprites']
	
	var max_value : float = float(IVCellCreator.max_stat_value)
	
	for i : int in stats.size():
		
		var stat_type : String = stats[i]
		var cell_stat : BrainCellStat = cell.get_stat(stat_type)
		
		var clean_bar : Sprite2D = clean_bars[i]
		var defect_bar : Sprite2D = defect_bars[i]
		
		# set clean stat value
		clean_bar.material.set_shader_parameter("old_prisoner_value", 0.0)
		clean_bar.material.set_shader_parameter("new_prisoner_value", cell_stat.value / max_value)
		
		# set defect stat value
		defect_bar.material.set_shader_parameter("prior_defect_value", 0.0)
		defect_bar.material.set_shader_parameter("new_defect_value", cell_stat.defect / max_value)

	for death_alert_sprite in death_alert_sprites : 	
		death_alert_sprite._toggle_skull(false)
		
	
	
	
	
	
	
	
	
