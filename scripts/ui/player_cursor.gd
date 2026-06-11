extends Sprite2D 

func _ready() -> void:
	GLChairBus.connect('toggle_player_sat_on_interpreter_chair', _handle_toggle_player_sat_on_interpreter_chair)

func _handle_toggle_player_sat_on_interpreter_chair(toggle_value : bool, _interpreter_type : String) :
	visible = !toggle_value
