extends Node


@export var is_selected_view_box : bool = false
@export var is_main_box : bool = false

# components
@onready var parent_box : Control = $".."
@onready var display_background: TextureRect = $"../DisplayBackground"
@onready var remove_border : TextureRect = $"../RemoveBorder"
@onready var add_a_cell_hint : Control = $"../AddACellHint"



var hovered: bool = false

func _ready() -> void:
	display_background.connect('mouse_entered', _handle_mouse_entered)
	display_background.connect('mouse_exited', _handle_mouse_exited)


func _process(_delta: float) -> void:
	if hovered :
		if parent_box.loaded_cell : 
			if Input.is_action_just_pressed('attack') : 
				
				if not is_selected_view_box : 
					parent_box._handle_box_empty(true, true)
				else : 
					parent_box._handle_box_empty(true)
				remove_border.visible = false
				
				


func _handle_mouse_entered() -> void:
	
	if is_main_box : 
		if parent_box.prevent_interact 	 :
			return
		
		
		
	
	
	if hovered:
		return

	hovered = true
	_handle_hover_start()


func _handle_mouse_exited() -> void:
	if not hovered:
		return

	hovered = false
	_handle_hover_end()


func _handle_hover_start() -> void:
	
	if parent_box.loaded_cell : 
		remove_border.visible = true
	else : 
		add_a_cell_hint.visible = true


func _handle_hover_end() -> void:
	
	if parent_box.loaded_cell : 
		remove_border.visible = false 
	else : 
		add_a_cell_hint.visible = false 
