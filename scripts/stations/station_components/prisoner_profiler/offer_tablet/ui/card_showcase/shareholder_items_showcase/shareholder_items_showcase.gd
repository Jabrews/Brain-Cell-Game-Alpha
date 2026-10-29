extends Control

@onready var toggle_focus : Node = $ToggleFocus


func _load_offer(_shareholder_items_card : ShareholderItemsCard) :
	pass

func _start() :
	toggle_focus._toggle(true)
	visible = true

func _stop() : 
	toggle_focus._toggle(false)
	visible = false
