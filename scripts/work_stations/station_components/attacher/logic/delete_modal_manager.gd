extends Node

# components
@onready var delete_modal : Control = $"../../AttacherUI/DeleteModal"
@onready var confirm_btn_bg : ColorRect = $"../../AttacherUI/DeleteModal/ConfirmBtn/BG"
@onready var deny_btn_bg : ColorRect = $"../../AttacherUI/DeleteModal/DenyBtn/BG"
@onready var attacher_ui_parent : Control = $"../../AttacherUI"
# helper components
@onready var handle_jar_delete_btn : Node = $"../BtnHandlers/HandleJarDeleteBtn"

var showing_delete_modal : bool = false

func _toggle_modal(toggle_value: bool) -> void:
	
	showing_delete_modal = toggle_value
	delete_modal.visible = toggle_value

	if toggle_value:
		confirm_btn_bg.focus_mode = Control.FOCUS_ALL
		deny_btn_bg.focus_mode = Control.FOCUS_ALL
		
		await get_tree().process_frame
		
		deny_btn_bg.grab_focus()
	else:
		confirm_btn_bg.focus_mode = Control.FOCUS_NONE
		deny_btn_bg.focus_mode = Control.FOCUS_NONE
		attacher_ui_parent.grab_focus()

func _handle_modal_btn(btn_type : String) :
	
	if not showing_delete_modal:
		push_error('somehow pressed modal button')
		return
	
	# send to jar delete btn (what this is important for)
	handle_jar_delete_btn._handle_modal_btn_pressed(btn_type)
