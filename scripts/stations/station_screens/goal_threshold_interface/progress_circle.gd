extends TextureRect

@onready var percant_label : Label = $PercantLabel
@onready var emergency_sprite : Sprite2D = $Emergency
@onready var disabled_blink_interval_timer : Timer = $DisabledBlinkInterval

func _ready() -> void:
	disabled_blink_interval_timer.connect('timeout', _handle_disabled_blink_interval_timer_timeout)


func _toggle_progress_active(toggle_value : bool) :
	if toggle_value : 
		disabled_blink_interval_timer.stop()
		percant_label.visible = true
		emergency_sprite.visible = false
	else : 
		if disabled_blink_interval_timer.is_stopped() :
			disabled_blink_interval_timer.start()

func _update_percant_label(max_value : int, curr_value : int) -> void:
	var percent : int = roundi(
		(1.0 - (float(curr_value) / float(max_value))) * 100.0
	)
	
	percant_label.text = str(percent) + "%"
	
	
func _handle_disabled_blink_interval_timer_timeout() :
	if percant_label.visible : 
		emergency_sprite.visible = true
		percant_label.visible = false
	else :
		emergency_sprite.visible = false
		percant_label.visible = true 
