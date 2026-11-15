extends Node

# components
@onready var parent_defect_decreaser : Node3D = $"../../.."
@onready var load_cell_panel : Area3D = $"../../../LoadCellPanel/Panel"
@onready var success_particles : GPUParticles3D = $"../../../SuccessParticles"

func _handle() : 
	
	if not parent_defect_decreaser.enabled : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	var defect_reduction_context : DefectReductionContext = parent_defect_decreaser.defect_reduction_context
	
	if not defect_reduction_context : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	if not defect_reduction_context.valid : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	## default logic ##
	var curr_defect_scraps : int = GLDefectScrapsBus.curr_defect_scraps	
	var scrap_cost : int = IVDefectDecreaser.cost_per_stat * len(defect_reduction_context.valid_stats)
	
	# show invalid text
	if scrap_cost > curr_defect_scraps : 	
		GLDefectDecreaserComponentBus.emit_signal('display_insufficient_funds')		
		GLDefectDecreaserComponentBus.emit_signal('play_sound', 'insufficent_funds')
		return
	
	# proceed with decrease
	else : 	
		GLDefectDecreaserComponentBus.emit_signal('display_success')		
		GLDefectScrapsBus.emit_signal('defect_scraps_changed', GLDefectScrapsBus.curr_defect_scraps - scrap_cost)
		
		GLCellManagerBus.emit_signal('defect_decreaser_used', defect_reduction_context.loaded_cell)
		
		GLCellManagerBus.emit_signal('scale_cell', defect_reduction_context.loaded_cell.name)
		
		GLDefectDecreaserComponentBus.emit_signal('play_sound', 'finished_charge')
		
		success_particles.emitting = true
		
		# refresh panel		
		load_cell_panel.monitoring = false
		await get_tree().process_frame
		load_cell_panel.monitoring = true 
		

	
	
	
	
	
	
