extends Control

@onready var time_left_label : Label = $TimeLeftLabel
@onready var emergency_sprite : Sprite2D = $EmergencySprite
@onready var emergency_bg : ColorRect = $BG
@onready var flash_interval_timer : Timer = $FlashIntervalTimer

var showing : bool = false
var inital_scale_tween : Tween

func _ready() -> void:
	GLGoalThresholdBus.connect('toggle_threshold_emergency_countdown', _handle_toggle_threshold_emergent_countdown)
	GLGoalThresholdBus.connect('update_emergency_time_left', _handle_update_emergency_time_left)
	flash_interval_timer.connect('timeout', _handle_flash_interval_timer)

func _handle_toggle_threshold_emergent_countdown(toggle_value : bool, time_left : int) :
	
	time_left_label.text = str(time_left)
	
	if toggle_value : 
		
		
		# prevent running inital startup twice
		if showing : 		
			return
		
		GLPlayerLocalSoundsBus.emit_signal('emergency_start')
		showing = true
		visible = true
		flash_interval_timer.start()		
		
	else :
		
		if not showing : 
			return
		
		GLPlayerLocalSoundsBus.emit_signal('emergency_end')
		showing = false
		visible = false
		flash_interval_timer.stop()
	
func _handle_flash_interval_timer() :
	visible = !visible
	
func _handle_update_emergency_time_left(time_left : int) :
	
	time_left_label.text = str(time_left)
	
	GLPlayerLocalSoundsBus.emit_signal('tick_sound')
	
