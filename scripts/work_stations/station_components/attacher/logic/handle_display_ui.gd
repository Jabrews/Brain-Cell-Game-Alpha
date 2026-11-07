extends Node

# components
@onready var attacher_ui : Control = $"../../AttacherUI"
@onready var refresh_catalog : Node = $"../RefreshCatalog"

var showing_attacher_ui : bool = false

func _ready() -> void:
	attacher_ui.visible = false

func _process(_delta: float) -> void:
	if attacher_ui: 
		if Input.is_action_just_pressed('back') : 
			_toggle_display(false)

func _toggle_display(toggle_value : bool) :
	
	attacher_ui.visible = toggle_value
	toggle_display_lock(toggle_value)	
	
	showing_attacher_ui= toggle_value
	
	if toggle_value : 
		refresh_catalog._refresh()
		return
	
	if not toggle_value : 
		GLAttacherComponentBus.emit_signal('toggle_show_view_attacher_label', true)
		return
		
	
func toggle_display_lock(toggle_value: bool) -> void:
	
	if toggle_value:
		GLHideUiBus.emit_signal('toggle_hide_ui', true)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		GLPlayerState.emit_signal('lock_player_position', true)
		attacher_ui.grab_focus()

	else:
		GLHideUiBus.emit_signal('toggle_hide_ui', false)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		GLPlayerState.emit_signal('lock_player_position', false)
