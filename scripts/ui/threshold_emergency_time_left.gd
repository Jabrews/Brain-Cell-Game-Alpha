extends Control

@onready var time_left_label : Label = $TimeLeftLabel
@onready var emergency_sprite : Sprite2D = $EmergencySprite
@onready var emergency_bg : ColorRect = $BG
@onready var flash_interval_timer : Timer = $FlashIntervalTimer

var showing : bool = false
var inital_scale_tween : Tween

func _ready() -> void:
	GLGoalThresholdBus.connect('toggle_threshold_emergent_countdown', _handle_toggle_threshold_emergent_countdown)
	flash_interval_timer.connect('timeout', _handle_flash_interval_timer)

func _handle_toggle_threshold_emergent_countdown(toggle_value : bool, time_left : int) :
	
	time_left_label.text = str(time_left)
	
	if toggle_value : 
		
		# prevent running inital startup twice
		if showing : 		
			return
		
		showing = true
		visible = true
		flash_interval_timer.start()		
		
		
	
	else :
		showing = false
		visible = false
		flash_interval_timer.stop()
	
func _handle_flash_interval_timer() :
	visible = !visible
	
