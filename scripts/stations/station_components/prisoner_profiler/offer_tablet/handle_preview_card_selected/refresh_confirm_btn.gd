extends Node

# components
@onready var confirm_btn : ColorRect = $"../../../../OfferUi/ConfirmFooter/ConfirmBtn"


func _refresh(selected_card_index : int) :
	
	if selected_card_index == -1 : 
		confirm_btn._toggle_confirm_btn_active(false)
	else :
		confirm_btn._toggle_confirm_btn_active(true)
