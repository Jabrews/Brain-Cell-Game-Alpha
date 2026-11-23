extends Node

# component handlers
@onready var handle_refresh_breeding_view : Node = $HandleRefreshBreederView
@export var cell_container_parent_node : Node

# panel cells
var left_main_cell: BrainCell
var right_main_cell: BrainCell
var left_boost_cell: BrainCell
var right_boost_cell: BrainCell
var left_boost_stat : String = 'none'
var right_boost_stat : String = 'none'
var left_boost_direction : String = 'none'
var right_boost_direction : String = 'none'


#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed('debug1') :
		#print('left boost stat : ', GLBreedingComponetsBus.left_boost_stat, ' | direction : ', GLBreedingComponetsBus.left_boost_direction)

func set_panel_cell(seat_type: String, cell: BrainCell) -> void:
	
	match seat_type:
		"left_main":
			left_main_cell = cell

		"right_main":
			right_main_cell = cell

		"left_boost":
			left_boost_cell = cell

		"right_boost":
			right_boost_cell = cell

		_:
			push_error("Invalid seat type: ", seat_type)
			return
			
	GLBreedingComponetsBus.breeding_panel_state[seat_type] = cell
	
	handle_refresh_breeding_view._handle_refresh()


func get_panel_cell(seat_type: String) -> BrainCell:
	match seat_type:
		"left_main":
			return left_main_cell

		"right_main":
			return right_main_cell

		"left_boost":
			return left_boost_cell

		"right_boost":
			return right_boost_cell

		_:
			push_error("Invalid seat type: ", seat_type)
			return null

func set_boost_stat(side : String, stat : String) : 
	match side : 
		'left'  :
			left_boost_stat = stat
			GLBreedingComponetsBus.left_boost_stat = stat
		'right' :
			right_boost_stat = stat
			GLBreedingComponetsBus.right_boost_stat = stat

func set_boost_direction(side : String, direction: String) : 
	match side : 
		'left'  :
			left_boost_direction = direction
			GLBreedingComponetsBus.left_boost_direction = direction 
		'right' :
			right_boost_direction = direction
			GLBreedingComponetsBus.right_boost_direction = direction 
