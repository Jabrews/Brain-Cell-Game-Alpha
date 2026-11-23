extends Node

@onready var btn_texture_rect : TextureRect = $BtnTextureRect

@onready var t_a_interact : Texture = preload("res://models/input_btns/a_interact.png")
@onready var t_left_click_interact : Texture = preload("res://models/input_btns/left_click_interact.png")


func _ready() -> void:
	GAMEInputTypeDetector.connect(
		"recieve_input_type_changed",
		_handle_recieve_input_type_changed
	)
	
	_update_button_texture(GAMEInputTypeDetector.input_type)


func _handle_recieve_input_type_changed(input_type : String) -> void:
	_update_button_texture(input_type)


func _update_button_texture(input_type : String) -> void:
	
	# this component is a special case:
	# controller = A
	# keyboard/mouse = left click
	
	if input_type == "controller":
		btn_texture_rect.texture = t_a_interact
	
	elif input_type == "keyboard":
		btn_texture_rect.texture = t_left_click_interact
