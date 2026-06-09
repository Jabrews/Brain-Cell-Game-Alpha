extends Node

# components
@onready var screen_defect_decrease : Node2D = $DefectDecreaseTv/TvFrontPannel/SubViewport/DefectDecrease
@onready var energy_cost_panel : Node3D = $EnergyCostPanel

var active_brain_cell : BrainCell


func _handle_panel_cell_recieved(brain_cell : BrainCell) :
	
	active_brain_cell = brain_cell
	
	if not IVCellDefectDecreaser.station_enabled :
		return
		
	# if not enough energy
	if IVCellDefectDecreaser.energy_cost > GLGameManagerBus.curr_energy :
		energy_cost_panel.display_out_of_energy()

	
	active_brain_cell = brain_cell
	
	screen_defect_decrease._display_defect_decrease_preview(brain_cell)

func _handle_confirm_btn_pressed() :
	
	if not IVCellDefectDecreaser.station_enabled :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
		
	# if not enough energy
	if IVCellDefectDecreaser.energy_cost > GLGameManagerBus.curr_energy :
		energy_cost_panel.display_out_of_energy()
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	if not active_brain_cell : 	
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
	
	GLCellManagerBus.emit_signal('defect_decreaser_used', active_brain_cell)	
	
	# decrease energy
	GLGameManagerBus.curr_energy -= IVCellDefectDecreaser.energy_cost
	
	GLGameManagerBus.emit_signal('energy_changed')
	
	
	
	
		
		
	
	
