extends Node

# components
@onready var detect_rect : ColorRect = $DetectRect
@onready var hover_bg : ColorRect = $HoverBG
@onready var hint_parent : Control = $FailureChanceHint

func _ready() -> void:
	detect_rect.connect('mouse_entered', _handle_mouse_entered)
	detect_rect.connect('mouse_exited', _handle_mouse_exited)
	detect_rect.connect('focus_entered', _handle_mouse_entered)
	detect_rect.connect('focus_exited', _handle_mouse_exited)

func _handle_mouse_entered() :
	hover_bg.visible = true
	hint_parent.visible = true

func _handle_mouse_exited() :
	hover_bg.visible = false 
	hint_parent.visible = false 
