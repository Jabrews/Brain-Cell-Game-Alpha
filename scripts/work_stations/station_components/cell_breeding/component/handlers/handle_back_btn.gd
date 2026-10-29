extends Node

# components
@onready var display_new_cell_preview : Node = $"../DisplayNewCellPreview"
@onready var confirm_btn_bg : ColorRect = $"../BreedingUI/InteractFooter/ConfirmBtn/BtnBg"

func _handle() :#
	display_new_cell_preview._close()
	
	if GAMEInputTypeDetector.input_type == 'controller' : 
		confirm_btn_bg.grab_focus()

	
