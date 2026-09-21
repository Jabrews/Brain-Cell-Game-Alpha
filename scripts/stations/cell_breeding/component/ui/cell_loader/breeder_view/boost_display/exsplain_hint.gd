extends Node

@onready var exsplain_bg : ColorRect = $BG
@onready var hint : Control = $Hint

func _ready() -> void:
	exsplain_bg.connect('mouse_entered', _handle_mouse_entered)
	exsplain_bg.connect('mouse_exited', _handle_mouse_exited)

func _handle_mouse_entered() :
	hint.visible = true
	
func _handle_mouse_exited() :
	hint.visible = false
