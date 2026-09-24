extends Node

# components
@onready var parent_new_cell_display : Control = $"../BreedingUI/NewCellDisplay"
@onready var parent_cell_loader_display : Control = $"../BreedingUI/CellLoader"
@onready var interact_footer : Control = $"../BreedingUI/InteractFooter"
@onready var handle_confirm_btn : Node = $"../HandleConfirmBtn"

func _display() :
	parent_cell_loader_display.visible = false
	parent_new_cell_display.visible = true 
	
	interact_footer._toggle_new_cell_preview(true)

func _close(): 
	parent_cell_loader_display.visible = true 
	parent_new_cell_display.visible = false 
	
	interact_footer._toggle_new_cell_preview(false)
	handle_confirm_btn.current_screen = 'cell_loader'
	
	
	


	
	
