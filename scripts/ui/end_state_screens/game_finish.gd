extends Control

@onready var retry_btn : Control = $Container/BtnContainer/RetryBtn

func _ready() -> void:
	GLEndStateScreenBus.connect('game_finished', _handle_game_ended)

func _handle_game_ended() :
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	
	if GAMEInputTypeDetector.input_type == 'controller': 
		await get_tree().process_frame
		retry_btn.grab_focus()
	
