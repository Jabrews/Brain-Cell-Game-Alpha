extends Node

# components
@onready var load_cell_panel : Area3D = $"../../../../LoadCellPanel/Panel"
@onready var success_particles : GPUParticles3D = $"../../../../Particles/SuccessParticles"
# floating label stuff
@onready var defect_scrap_floating_label_p_s : PackedScene = preload("res://scenes/work_stations/station_components/defect_scrap_floating_label/defect_scrap_floating_label.tscn")
@onready var floating_label_spawn_pos : Node3D = $"../../../../FloatingLabelSpawnPos"


func _success(loaded_cell : BrainCell, selected_stat_type : String) :
	
	var selected_stat : BrainCellStat = loaded_cell.get_stat(selected_stat_type)
	
	if not selected_stat : 
		push_error('unable to find selected stat for type : ', selected_stat_type )
		return
	
	if not selected_stat.enabled or selected_stat.hidden : 
		push_error('invalid stat selected, hidden or disabled')
		return
	
	### add to jar state
	
	var jar_item_stat : JarCellStat = JarCellStat.new(selected_stat)
	
	if len(GLJarComponentBus.jar_items) >= 4 : 
		print_debug('should deal with jar being over filled, let user know')
		return
	else  :
		GLJarComponentBus.emit_signal('add_jar_item', jar_item_stat)
	
	## get rid of enabled stat on cell and update
	
	match selected_stat_type : 
		'strength' : 
			loaded_cell.strength.enabled = false
			loaded_cell.strength.value = 0.0
			loaded_cell.strength.defect = 0.0
		'intelligence' : 
			loaded_cell.intelligence.enabled = false
			loaded_cell.intelligence.value = 0.0
			loaded_cell.intelligence.defect = 0.0
		'community' : 
			loaded_cell.community.enabled = false
			loaded_cell.community.value = 0.0
			loaded_cell.community.defect = 0.0	
	
	GLCellManagerBus.emit_signal('collected_cell_changed', loaded_cell)
	
	# scale cell + sound 
	GLCellManagerBus.emit_signal('scale_cell', loaded_cell.name)
	success_particles.emitting = true
	
	# show success parent on main screen and breeder screen 
	GLDetacherComponentBus.emit_signal('show_success_screen')	
	
	# reset display. just do via refresing cell panel
	load_cell_panel.monitoring = false
	await get_tree().process_frame
	load_cell_panel.monitoring = true 
	
	# increase defect scrap
	await get_tree().process_frame
	GLDefectScrapsBus.emit_signal('defect_scraps_changed', GLDefectScrapsBus.curr_defect_scraps + 10)
	
	# floating label
	var defect_scrap_floating_label_instance : Node3D = defect_scrap_floating_label_p_s.instantiate()	
	add_child(defect_scrap_floating_label_instance)
	defect_scrap_floating_label_instance.global_position = floating_label_spawn_pos.global_position
	defect_scrap_floating_label_instance.start(10)
	
