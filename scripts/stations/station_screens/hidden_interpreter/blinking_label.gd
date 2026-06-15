extends Label 

@onready var blink_timer : Timer = $BlinkTimer

func _ready() -> void:
	blink_timer.start()

func _on_blink_timer_timeout() -> void:
	visible = !visible
