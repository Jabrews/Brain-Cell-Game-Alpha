extends Node

# components
@onready var bg : ColorRect = $BG
@onready var hover_bg : ColorRect = $HoverBG
@onready var hint_parent : Control = $FailureChanceHint

func _ready() -> void:
	bg.connect('mouse_entered', _handle_mouse_entered)
	bg.connect('mouse_exited', _handle_mouse_exited)

func _handle_mouse_entered() :
	hover_bg.visible = true
	hint_parent.visible = true

func _handle_mouse_exited() :
	hover_bg.visible = false 
	hint_parent.visible = false 
