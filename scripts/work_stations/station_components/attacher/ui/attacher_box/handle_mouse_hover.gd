extends Node

# components
@onready var parent_attacher_box : Control = $".."
@onready var display_background : TextureRect = $"../DisplayBackground"
@onready var selected_border : TextureRect = $"../SelectedBorder"
@onready var add_a_cell_hint : Control = $"../AddACellHint"

func _ready() -> void:
	display_background.connect('mouse_entered', _handle_mouse_entered)
	display_background.connect('mouse_exited', _handle_mouse_exited)
	display_background.connect('focus_entered', _handle_mouse_entered)
	display_background.connect('focus_exited', _handle_mouse_exited)

func _handle_mouse_entered() :
	selected_border.visible = true
	
	if parent_attacher_box.loaded_cell == null : 
		add_a_cell_hint.visible = true 

func _handle_mouse_exited() :
	selected_border.visible = false 
	
	add_a_cell_hint.visible = false 
