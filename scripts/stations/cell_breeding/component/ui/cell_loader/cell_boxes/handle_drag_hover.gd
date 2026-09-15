extends Node

# components
@onready var parent_box : Control = $".."
@onready var selected_border: TextureRect = $"../SelectedBorder"
@onready var display_background: TextureRect = $"../DisplayBackground"
@onready var blink_selected_border_timer : Timer = $BlinkSelectedBorder
@onready var already_occupied_hint : Control = $"../AlreadyOccupiedHint"

var hovered: bool = false

func _ready() -> void:
	blink_selected_border_timer.connect('timeout', _handle_blink_selected_border_timer_timeout)


func _process(_delta: float) -> void:
	var currently_hovered: bool = false
	
	for child in parent_box.drag_cell_entry_parent_node.get_children():
		if child is Control:
			if display_background.get_global_rect().intersects(
				child.display_background.get_global_rect()
			):
				currently_hovered = true
				break
	
	# hover started
	if currently_hovered and not hovered:
		hovered = true
		_handle_hover_on()
	
	# hover ended
	elif not currently_hovered and hovered:
		hovered = false
		_handle_hover_off()


func _handle_hover_on() -> void:
	
	if parent_box.loaded_cell :
		blink_selected_border_timer.start()
		already_occupied_hint.visible = true
		GLBreedingComponetsBus.emit_signal('breeder_play_sound', 'error')
	
	selected_border.visible = true


func _handle_hover_off() -> void:
	
	blink_selected_border_timer.stop()	
	
	already_occupied_hint.visible = false
	
	selected_border.visible = false
	
	
func _handle_blink_selected_border_timer_timeout() : 
	selected_border.visible = !selected_border.visible
