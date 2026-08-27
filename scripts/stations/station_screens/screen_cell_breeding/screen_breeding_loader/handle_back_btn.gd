
extends Node

# display componnets
@onready var press_to_see_result_label : Label = $"../SeatCellLoading/PressBtnToSeeResult"
@onready var parent_seat_cell_loading : Node2D = $"../SeatCellLoading"
@onready var parent_new_cell_preview : Node2D = $"../NewCellPreview"
# disrupt stuff
@onready var parent_disrupt_manager_loader : Control = $"../DisruptorManagerSeatLoading"
@onready var parent_disrupt_new_cell : Control = $"../DisruptorManagerNewCell"
# other confirm helper, kinda hacky 
@onready var helper_handle_confirm_btn : Node = $"../HandleConfirmBtn"


func _ready() -> void:
	show_loader_display(false)

func _handle_btn_pressed() -> void:
	
	## verify current screen is new cell preview
	## if so then go back to prior screen	
	
	if parent_new_cell_preview.visible == true :
		if parent_seat_cell_loading.visible == false : 
			show_loader_display(true)
	
	## TODO set up checking for this ahead of time and not calling and player sound_failed first 
	
	
	




func show_loader_display(show_label: bool) -> void:
	helper_handle_confirm_btn.new_cell_display_shown = false
	helper_handle_confirm_btn.can_breed = false
	
	parent_seat_cell_loading.visible = true
	parent_disrupt_manager_loader.visible = true
	parent_new_cell_preview.visible = false
	parent_disrupt_new_cell.visible = false
	press_to_see_result_label.visible = show_label


	
