extends Node

@onready var exsplain_bg : ColorRect = $BG
@onready var hint_parent : Control = $HintParent

func _ready() -> void:
	exsplain_bg.connect('mouse_entered', _handle_mouse_entered)
	exsplain_bg.connect('mouse_exited', _handle_mouse_exited)
	
func _handle_mouse_entered() :
	hint_parent.visible = true
	
func _handle_mouse_exited() :
	hint_parent.visible = false
