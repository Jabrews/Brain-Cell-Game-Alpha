extends Control

@onready var time_left_label : Label = $TimeLeftLabel
@onready var emergency_sprite : Sprite2D = $EmergencySprite
@onready var emergency_bg : ColorRect = $BG

var showing : bool = false
var inital_scale_tween : Tween


func _ready() -> void:
	GLGoalThresholdBus.connect('toggle_threshold_emergency_countdown', _handle_toggle_threshold_emergent_countdown)
	GLGoalThresholdBus.connect('update_emergency_time_left', _handle_update_emergency_time_left)
	
	GLHideUiBus.connect('toggle_hide_ui', _handle_toggle_hide_ui)

func _handle_toggle_threshold_emergent_countdown(toggle_value : bool, time_left : int) :
	
	time_left_label.text = str(time_left)
	
	if toggle_value : 
		
		
		# prevent running inital startup twice
		if showing : 		
			return
		
		GLPlayerLocalSoundsBus.emit_signal('emergency_start')
		showing = true
		visible = true
		
	else :
		
		if not showing : 
			return
		
		GLPlayerLocalSoundsBus.emit_signal('emergency_end')
		showing = false
		visible = false
	
func _handle_update_emergency_time_left(time_left : int) :
	
	time_left_label.text = str(time_left)
	
	GLPlayerLocalSoundsBus.emit_signal('tick_sound')
	
func _handle_toggle_hide_ui(toggle_value : bool) : 
	
	if toggle_value : 
		visible = !toggle_value 
		
		
	
	else : 
		if showing : 
			visible = true 
		else : 
			visible = false 
