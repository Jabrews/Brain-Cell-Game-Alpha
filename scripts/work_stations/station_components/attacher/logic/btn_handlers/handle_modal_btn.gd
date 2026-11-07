extends Node

# components
@onready var handle_jar_delete_btn : Node = $"../HandleJarDeleteBtn"

func _handle(btn_type : String) :
	
	if not handle_jar_delete_btn.showing_delete_modal :
		push_error('somehow pressed modal button')
		return
	
	# send to jar delete btn (what this is important for)
	handle_jar_delete_btn._handle_modal_btn_pressed(btn_type)
