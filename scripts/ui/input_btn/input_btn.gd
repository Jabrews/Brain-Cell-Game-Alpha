extends Control

# button textures
@onready var t_a_interact : Texture = preload("res://models/input_btns/a_interact.png") # controller
@onready var t_b_drop : Texture = preload("res://models/input_btns/b_drop.png") # controller
@onready var t_e_interact : Texture = preload("res://models/input_btns/e_interact.png") # keyboard
@onready var t_f_drop : Texture = preload("res://models/input_btns/f_drop.png") # keyboard

# leave below texture for later idc for now
@onready var t_left_click_interact : Texture = preload("res://models/input_btns/left_click_interact.png")

# components
@onready var btn_texture_rect : TextureRect = $BtnTextureRect

@export var button_input_action : String = "interact"


func _ready() -> void:
	GAMEInputTypeDetector.connect(
		"recieve_input_type_changed",
		_handle_recieve_input_type_changed
	)
	
	_update_button_texture(GAMEInputTypeDetector.input_type)


func _handle_recieve_input_type_changed(input_type : String) -> void:
	_update_button_texture(input_type)


func _update_button_texture(input_type : String) -> void:
	
	if input_type == "controller":
		
		match button_input_action:
			"interact":
				btn_texture_rect.texture = t_a_interact
			
			"drop_item":
				btn_texture_rect.texture = t_b_drop
	
	
	elif input_type == "keyboard":
		
		match button_input_action:
			"interact":
				btn_texture_rect.texture = t_e_interact
			
			"drop_item":
				btn_texture_rect.texture = t_f_drop
