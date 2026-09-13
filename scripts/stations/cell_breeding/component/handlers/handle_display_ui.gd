extends Node

# components
@onready var breeding_ui : Control = $"../BreedingUI"
@onready var selected_view_box : Control = $"../BreedingUI/CellLoader/SelectedView/SelectedViewBox"

# display helpers
@onready var display_cell_catalog : Node = $"../DisplayCellCatalog"

# handler helpers
@onready var handle_breeding_box_startup : Node = $"../HandleBreedingBoxStartup"



func _toggle_display(toggle_value : bool) :
	
	breeding_ui.visible = toggle_value
	toggle_display_lock(toggle_value)	
	
	if toggle_value : 
		
		# display 
		display_cell_catalog._display()
		handle_breeding_box_startup._handle()
	
	if not toggle_value : 
		# user will always get out breeder in area
		GLBreedingComponetsBus.emit_signal('toggle_show_view_breeder_label', true)
		
		# reset
		display_cell_catalog._reset()
		selected_view_box._handle_box_empty()
		
	
	
	
func toggle_display_lock(toggle_value: bool) -> void:
	
	if toggle_value:
		GLHideUiBus.emit_signal('toggle_hide_ui', true)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		GLPlayerState.emit_signal('lock_player_position', true)

	else:
		GLHideUiBus.emit_signal('toggle_hide_ui', false)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		GLPlayerState.emit_signal('lock_player_position', false)
