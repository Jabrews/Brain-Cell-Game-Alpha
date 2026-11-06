extends Node

# components
@onready var hover_border : ColorRect = $HoverBorder
@onready var penality_hint : Control = $PenalityHint
@onready var bg : ColorRect = $BG

func _ready() -> void:
	bg.connect('mouse_entered', _handle_mouse_entered)
	bg.connect('mouse_exited', _handle_mouse_exited)

func _handle_mouse_entered() :
	hover_border.visible = true
	penality_hint.visible = true
	
func _handle_mouse_exited() :
	hover_border.visible = false 
	penality_hint.visible = false 
