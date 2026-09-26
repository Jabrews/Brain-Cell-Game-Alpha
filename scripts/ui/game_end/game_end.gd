extends Control

@onready var retry_btn_bg : ColorRect = $RetryBtn/ColorRect2

func _ready() -> void:
	GLGameEndBus.connect('game_ended', _handle_game_ended)

func _handle_game_ended() :
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	
	if GAMEInputTypeDetector.input_type == 'controller': 
		await get_tree().process_frame
		retry_btn_bg.grab_focus()
	
