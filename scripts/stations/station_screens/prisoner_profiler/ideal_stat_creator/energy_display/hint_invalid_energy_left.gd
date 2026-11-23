extends Control

@onready var emergy_sprite: Sprite2D = $EnergySymbol
@onready var emergency_blink_timer : Timer = $EmergencyBlinkTimer

func _ready() -> void:
	emergency_blink_timer.connect('timeout', _handle_timeout)
	emergency_blink_timer.start()

func _activate(toggle_value : bool) :
	
	visible = toggle_value
	
	if toggle_value : 	
		if emergency_blink_timer.is_stopped() : 		
			emergency_blink_timer.start()
			emergy_sprite.visible = true
	else :
		emergency_blink_timer.stop()
		emergy_sprite.visible = false 

func _handle_timeout() :
	emergy_sprite.visible = !emergy_sprite.visible
	
	if emergy_sprite.visible : 
		GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'energy_alert_beep')
