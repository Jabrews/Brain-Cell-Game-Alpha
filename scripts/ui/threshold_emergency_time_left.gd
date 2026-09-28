extends Control

@onready var warning_left_label : Label = $WarningLabel
@onready var emergency_sprite : Sprite2D = $EmergencySprite
@onready var flash_timer : Timer = $FlashTimer

func _ready() -> void:
	GLGoalThresholdManagerBus.connect('toggle_emergency_ui', _handle_toggle_emergency_ui)
	flash_timer.connect('timeout', _handle_flash_timer_timeout)	
	
	
	GLHideUiBus.connect('toggle_hide_ui', _handle_toggle_hide_ui)
	
func _handle_toggle_emergency_ui(toggle_value : bool) :
	
	if toggle_value : 	
		visible = true 
		warning_left_label.visible = true
		emergency_sprite.visible = true
		flash_timer.start()
	else : 
		flash_timer.stop()
		visible = false

func _handle_flash_timer_timeout():
		warning_left_label.visible = !warning_left_label.visible 
		emergency_sprite.visible = !emergency_sprite.visible 


func _handle_toggle_hide_ui() : 
	visible = false
