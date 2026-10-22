extends Sprite2D 

func _ready() -> void:
	GLPlayerState.connect('lock_player_position', _handle_lock_player_position)
	GLHideUiBus.connect('toggle_hide_ui', _handle_toggle_hide_ui)

func _handle_lock_player_position(toggle_value : bool) :
	visible = !toggle_value

func _handle_toggle_hide_ui(toggle_value : bool) : 
	visible = !toggle_value
