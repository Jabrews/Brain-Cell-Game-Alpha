extends Node

# components
@onready var breeding_ui : Control = $"../BreedingUI"
@onready var selected_view_box : Control = $"../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/BoxSection/SelectedViewBox"

# display helpers
@onready var display_cell_catalog : Node = $"../DisplayCellCatalog"
@onready var display_new_cell_preview : Node = $"../DisplayNewCellPreview"

# handler helpers
@onready var handle_breeding_box_startup : Node = $"../HandleBreedingBoxStartup"
@onready var handle_toggle_selected_view_slider : Node = $"../HandleSelectedViewSlider"

var showing_breeding_ui : bool = false

func _ready() -> void:
	breeding_ui.visible = false

func _process(_delta: float) -> void:
	if showing_breeding_ui : 
		if Input.is_action_just_pressed('back') : 
			_toggle_display(false)

func _toggle_display(toggle_value : bool) :
	
	breeding_ui.visible = toggle_value
	toggle_display_lock(toggle_value)	
	
	showing_breeding_ui = toggle_value
	
	if toggle_value : 
		
		# refresh briefly
		GLBreedingComponetsBus.emit_signal('initate_breeder_refresh')
		
		GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'open_hologram')
		
		# display 
		display_cell_catalog._display()
		handle_breeding_box_startup._handle()
		
		# close slider
		handle_toggle_selected_view_slider._handle(false)
		
		# close new cell preview
		display_new_cell_preview._close()
	
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
		breeding_ui.grab_focus()

	else:
		GLHideUiBus.emit_signal('toggle_hide_ui', false)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		GLPlayerState.emit_signal('lock_player_position', false)
