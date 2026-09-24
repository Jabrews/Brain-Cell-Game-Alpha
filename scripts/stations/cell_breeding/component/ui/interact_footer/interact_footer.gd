extends Node

# components
@onready var confirm_btn : Control = $ConfirmBtn
@onready var back_btn : Control = $BackBtn

var confirm_btn_default_pos : Vector2
var confirm_btn_cell_preview_pos : Vector2 = Vector2(700.0, 670.0)


func _ready() -> void:
	
	confirm_btn_default_pos = confirm_btn.position
	
	_toggle_new_cell_preview(false)
	

func _toggle_new_cell_preview(toggle_value : bool) : 
	
	confirm_btn.visible = false
	back_btn.visible = false
	
	await get_tree().create_timer(0.3).timeout
	
	confirm_btn.visible = true
	
	if toggle_value :	
		confirm_btn.position = confirm_btn_cell_preview_pos
		back_btn.visible = true	

		
	else : 
		confirm_btn.position = confirm_btn_default_pos
		back_btn.visible = false 
	
	
