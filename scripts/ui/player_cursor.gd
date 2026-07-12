extends Sprite2D 

func _ready() -> void:
	GLPlayerState.connect('lock_player_position', _handle_lock_player_position)

func _handle_lock_player_position(toggle_value : bool) :
	visible = !toggle_value
