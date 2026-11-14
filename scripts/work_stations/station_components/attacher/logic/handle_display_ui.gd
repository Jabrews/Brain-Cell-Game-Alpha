extends Node

# components
@onready var attacher_ui : Control = $"../../AttacherUI"
@onready var delete_modal_manager : Node = $"../DeleteModalManager"
@onready var refresh_ui : Node = $"../RefreshUi"
@onready var parent_grid_container : GridContainer = $"../../AttacherUI/JarItemCatalog/CenterContainer/ScrollContainer/GridContainerLeft"
var showing_attacher_ui : bool = false

func _ready() -> void:
	attacher_ui.visible = false
	
	GLAttacherComponentBus.connect('reset_ui_focus', _handle_reset_ui_focus)

func _process(_delta: float) -> void:
	if attacher_ui: 
		if Input.is_action_just_pressed('back') : 
			if showing_attacher_ui : 
				_toggle_display(false)

func _toggle_display(toggle_value : bool) :
	
	attacher_ui.visible = toggle_value
	toggle_display_lock(toggle_value)	
	
	showing_attacher_ui= toggle_value
	
	if toggle_value : 
		
		refresh_ui._refresh()
		
		GLAttacherComponentBus.emit_signal('play_sound', 'enter_ui')
		
		# just stops new item visual early (jar & hologram)
		GLAttacherComponentBus.emit_signal('opened_attacher')
		
		return
	
	if not toggle_value : 
		GLAttacherComponentBus.emit_signal('toggle_show_view_attacher_label', true)
		delete_modal_manager._toggle_modal(false)
		# clear catalog
		for jar_item: Control in parent_grid_container.get_children():
			jar_item.queue_free()
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

func _handle_reset_ui_focus() :
	await get_tree().process_frame
	
	if attacher_ui.visible : 
		attacher_ui.grab_focus()
