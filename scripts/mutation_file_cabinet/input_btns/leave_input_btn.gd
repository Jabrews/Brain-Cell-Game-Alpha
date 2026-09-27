extends Control

# button textures
@onready var t_b_drop : Texture = preload("res://models/input_btns/b_drop.png") # controller
@onready var t_e_interact : Texture = preload( "res://models/input_btns/e_interact.png") # keyboard

# components
@onready var btn_texture_rect : TextureRect = $BtnTextureRect


func _ready() -> void:
	GAMEInputTypeDetector.connect(
		"recieve_input_type_changed",
		_handle_recieve_input_type_changed
	)
	
	_update_button_texture(GAMEInputTypeDetector.input_type)


func _handle_recieve_input_type_changed(input_type : String) -> void:
	_update_button_texture(input_type)


func _update_button_texture(input_type : String) -> void:
	
	# cabinet leave is a special case:
	# controller = B
	# keyboard = E
	
	if input_type == "controller":
		btn_texture_rect.texture = t_b_drop
	
	elif input_type == "keyboard":
		btn_texture_rect.texture = t_e_interact
