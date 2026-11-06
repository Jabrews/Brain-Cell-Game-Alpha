extends Control

# components
@onready var btn_bg : TextureRect = $BtnBG
@onready var hover_border : TextureRect = $HoverBorder
@onready var remove_hint : Control = $RemoveHint

func _ready() -> void:
	btn_bg.connect('mouse_entered', _handle_mouse_entered)
	btn_bg.connect('mouse_exited', _handle_mouse_exited)

func _handle_mouse_entered() :
	hover_border.visible = true
	remove_hint.visible = true
	
func _handle_mouse_exited() :
	hover_border.visible = false 
	remove_hint.visible = false 
