extends Node

@onready var screen_handle_confirm_btn_pressed : Node = $"../BreedPreviewTv/TvFrontPannel/SubViewport/ScreenCellBreedingLoader/HandleConfirmBtn"
@onready var main_cell_manager : Node = $"../MainCellManager"


func _handle_confirm_btn_pressed() :
	
	if main_cell_manager.main_left_cell and main_cell_manager.main_right_cell :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
		screen_handle_confirm_btn_pressed._handle_btn_pressed()
	else: 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		
		
	
	
	
