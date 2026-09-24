extends Node

# components
@onready var parent_drag_cell_entry : Control = $".."
@onready var display_background : ColorRect = $"../DisplayBackground"

# component boxes
@onready var selected_view_box : Control = $"../../../CellLoader/SelectedViewSlider/SlideContent/BoxSection/SelectedViewBox"
@onready var left_breeding_view_main_box : Control = $"../../../CellLoader/BreedingView/Boxes/LeftBreedingViewMainBox"
@onready var right_breeding_view_main_box : Control = $"../../../CellLoader/BreedingView/Boxes/RightBreedingViewMainBox"
@onready var left_breeding_view_boost_box : Control = $"../../../CellLoader/BreedingView/Boxes/LeftBreedingViewBoostBox"
@onready var right_breeding_view_boost_box : Control = $"../../../CellLoader/BreedingView/Boxes/RightBreedingViewBoostBox"


# extra detection area around each box
@export_category("Drop Detection Radius")

@export var selected_view_radius : float = 20.0

@export var left_main_radius : float = 20.0
@export var right_main_radius : float = 20.0

@export var left_boost_radius : float = 20.0
@export var right_boost_radius : float = 20.0


func _handle() -> void:
	var loaded_cell : BrainCell = parent_drag_cell_entry.loaded_cell
	
	var drag_rect : Rect2 = display_background.get_global_rect()
	
	
	# selected view box
	if drag_rect.intersects(
		_get_increased_rect(
			selected_view_box.display_background,
			selected_view_radius
		)
	):
		selected_view_box._handle_entry_dropped(loaded_cell)
	
	
	# left main box
	elif drag_rect.intersects(
		_get_increased_rect(
			left_breeding_view_main_box.display_background,
			left_main_radius
		)
	):
		left_breeding_view_main_box._handle_entry_dropped(
			loaded_cell,
			true,
			true
		)
	
	
	# right main box
	elif drag_rect.intersects(
		_get_increased_rect(
			right_breeding_view_main_box.display_background,
			right_main_radius
		)
	):
		right_breeding_view_main_box._handle_entry_dropped(
			loaded_cell,
			true,
			true
		)
	
	
	# left boost box
	elif drag_rect.intersects(
		_get_increased_rect(
			left_breeding_view_boost_box.display_background,
			left_boost_radius
		)
	):
		left_breeding_view_boost_box._handle_entry_dropped(
			loaded_cell,
			true,
			true
		)
	
	
	# right boost box
	elif drag_rect.intersects(
		_get_increased_rect(
			right_breeding_view_boost_box.display_background,
			right_boost_radius
		)
	):
		right_breeding_view_boost_box._handle_entry_dropped(
			loaded_cell,
			true,
			true
		)
	
	
	# default drop sound
	else:
		GLBreedingComponetsBus.emit_signal(
			'breeder_play_sound',
			'dropped'
		)


func _get_increased_rect(control : Control, radius : float) -> Rect2:
	var global_rect : Rect2 = control.get_global_rect()
	return global_rect.grow(radius)
