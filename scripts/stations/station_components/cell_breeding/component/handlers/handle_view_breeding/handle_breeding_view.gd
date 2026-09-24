extends Node

# get helper
@onready var get_side_components : Node = $GetSideComponents

# display components
@onready var display_stats : Node = $Display/DisplayStats
@onready var display_boost : Node = $Display/DisplayBoost
@onready var display_stat_symbols : Node = $Display/DisplayStatSymbols
@onready var display_death_chance : Node = $Display/DisplayDeathChance
@onready var display_blood_type : Node = $Display/DisplayBloodType
@onready var display_death_chance_skull : Node = $Display/DisplayDeathChanceSkull


func _ready() -> void:
	GLBreedingComponetsBus.connect('refresh_stat_display', _handle)


func _handle() -> void:
	
	var ui_cells : Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_ui_state
	
	# get main cells
	var left_main_cell : BrainCell = ui_cells["left_main"]
	var right_main_cell : BrainCell = ui_cells["right_main"]
	
	# display stats
	var left_stat_components : Dictionary = get_side_components._get_stat("left")
	display_stats._display(left_main_cell, left_stat_components)
	
	var right_stat_components : Dictionary = get_side_components._get_stat("right")
	display_stats._display(right_main_cell, right_stat_components)
	
	# display boost 	
	var left_boost_stat : String = GLBreedingComponetsBus.left_boost_stat
	var left_boost_direction : String = GLBreedingComponetsBus.left_boost_direction
	var right_boost_stat : String = GLBreedingComponetsBus.right_boost_stat
	var right_boost_direction : String = GLBreedingComponetsBus.right_boost_direction
	
	display_boost._display(left_stat_components, left_main_cell, left_boost_stat, left_boost_direction)
	display_boost._display(right_stat_components, right_main_cell, right_boost_stat, right_boost_direction)
	
	# display stat symbols	
	if left_main_cell and right_main_cell :
		display_stat_symbols.check_for_symbols(left_main_cell, right_main_cell)
	else :
		display_stat_symbols.hide_symbols()
	
	# display death chance
	var left_death_chance_components : Dictionary = get_side_components._get_death_chance('left')
	display_death_chance._display(left_main_cell, left_death_chance_components)

	var right_death_chance_components : Dictionary = get_side_components._get_death_chance('right')
	display_death_chance._display(right_main_cell, right_death_chance_components)
	
	
	# display death chance skull
	display_death_chance_skull._display(left_main_cell, right_main_cell)
	
	# display blood type
	var left_blood_type_components : Dictionary = get_side_components._get_blood_type('left')
	display_blood_type._display(left_main_cell, left_blood_type_components)
	
	var right_blood_type_components : Dictionary = get_side_components._get_blood_type('right')
	display_blood_type._display(right_main_cell, right_blood_type_components)
	
