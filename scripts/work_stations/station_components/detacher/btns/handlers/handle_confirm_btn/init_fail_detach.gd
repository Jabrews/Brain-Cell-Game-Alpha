extends Node

# components
@onready var load_cell_panel : Area3D = $"../../../../LoadCellPanel/Panel"
@onready var failed_particles : GPUParticles3D = $"../../../../Particles/FailedParticles"


func _failed(loaded_cell : BrainCell, selected_stat_type : String) :

	var selected_stat : BrainCellStat = loaded_cell.get_stat(selected_stat_type)
	
	if not selected_stat : 
		push_error('unable to find selected stat for type : ', selected_stat_type )
		return
	
	if not selected_stat.enabled or selected_stat.hidden : 
		push_error('invalid stat selected, hidden or disabled')
		return

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
	failed_particles.emitting = true

	# show fail parent on main screen and breeder screen 
	GLDetacherComponentBus.emit_signal('show_failed_screen')	
	
	# reset display. just do via refresing cell panel
	load_cell_panel.monitoring = false
	await get_tree().process_frame
	load_cell_panel.monitoring = true 
	
	
