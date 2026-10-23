extends Node

# components
@onready var offer_ui : Control = $"../../../OfferUi"

func _ready() -> void:
	_toggle(false)

func _toggle(toggle_value : bool) :
	
	offer_ui.visible = toggle_value	
	
	toggle_display_lock(toggle_value)
	
	if toggle_value  :
		GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'tablet_open')
	
func toggle_display_lock(toggle_value: bool) -> void:
	
	if toggle_value:
		GLHideUiBus.emit_signal('toggle_hide_ui', true)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		GLPlayerState.emit_signal('lock_player_position', true)
		offer_ui.grab_focus()

	else:
		GLHideUiBus.emit_signal('toggle_hide_ui', false)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		GLPlayerState.emit_signal('lock_player_position', false)
