extends Node


@onready var blink : Control = $Blink


func _toggle_active(toggle_value : bool) :
	blink._toggle(toggle_value)
