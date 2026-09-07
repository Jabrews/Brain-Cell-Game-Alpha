extends Control

func _ready() -> void:
	GLGameEndBus.connect('game_ended', _handle_game_ended)

func _handle_game_ended() :
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
