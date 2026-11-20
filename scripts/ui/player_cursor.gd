extends TextureRect

func _ready() -> void:
	GLPlayerState.connect('lock_player_position', _handle_lock_player_position)
	GLHideUiBus.connect('toggle_hide_ui', _handle_toggle_hide_ui)
	get_viewport().size_changed.connect(_update_cursor)
	_update_cursor()
	

func _handle_lock_player_position(toggle_value : bool) :
	visible = !toggle_value

func _handle_toggle_hide_ui(toggle_value : bool) : 
	visible = !toggle_value
	
	
func _update_cursor() -> void:
	var resolution := get_viewport_rect().size

	if resolution.x > 1920 or resolution.y > 1080:
		size = Vector2(22, 22)
		set_anchors_and_offsets_preset(Control.PRESET_CENTER)
