extends Node

# base display components

# left
@onready var left_cell_stat_diplay: Control = $"../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay"
@onready var left_no_cell_label: Label = $"../../SeatCellLoading/StatDisplay/LeftStatDisplay/NoCellLoadedLabel"
@onready var left_death_chance_display: Node2D = $"../../SeatCellLoading/DeathChanceDisplay/LeftDeathChanceDisplay"
@onready var left_blood_type_display: Node2D = $"../../SeatCellLoading/BloodType/LeftBloodTypeDisplay"

# left loading
@onready var left_death_chance_loading_spinner: AnimatedSprite2D = $"../../SeatCellLoading/DeathChanceDisplay/LeftLoadingSpinner"
@onready var left_blood_type_loading_spinner: AnimatedSprite2D = $"../../SeatCellLoading/BloodType/LeftLoadingSpinner"

# right
@onready var right_cell_stat_diplay: Control = $"../../SeatCellLoading/StatDisplay/RightStatDisplay/StatDisplay"
@onready var right_no_cell_label: Label = $"../../SeatCellLoading/StatDisplay/RightStatDisplay/NoCellLoadedLabel"
@onready var right_death_chance_display: Node2D = $"../../SeatCellLoading/DeathChanceDisplay/RightDeathChanceDisplay"
@onready var right_blood_type_display: Node2D = $"../../SeatCellLoading/BloodType/RightBloodTypeDisplay"

# right loading
@onready var right_death_chance_loading_spinner: AnimatedSprite2D = $"../../SeatCellLoading/DeathChanceDisplay/RightLoadingSpinner"
@onready var right_blood_type_loading_spinner: AnimatedSprite2D = $"../../SeatCellLoading/BloodType/RightLoadingSpinner"

# loading timer
@onready var left_death_delay_timer : Timer = $LoadingSpinnerTimers/LeftDeathDelay
@onready var right_death_delay_timer : Timer = $LoadingSpinnerTimers/RighttDeathDelay
@onready var left_blood_delay_timer : Timer = $LoadingSpinnerTimers/LeftBloodDelay
@onready var right_blood_delay_timer : Timer = $LoadingSpinnerTimers/RightBloodDelay



# reset helper components
@onready var reset_stat_left: Node = $Reset/ResetStatLeft
@onready var reset_death_chance_left : Node = $Reset/ResetDeathChanceLeft

@onready var reset_stat_right: Node = $Reset/ResetStatRight
@onready var reset_death_chance_right : Node = $Reset/ResetDeathChanceRight

# both side loaders
@onready var reset_death_chance_skull : Node = $Reset/ResetDeathChanceSkull

# load cell helper components
@onready var display_stat_left: Node = $Display/DisplayStatLeft
@onready var display_death_chance_left : Node = $Display/DisplayDeathChanceLeft

@onready var display_stat_right: Node = $Display/DisplayStatRight
@onready var display_death_chance_right : Node = $Display/DisplayDeathChanceRight

# both side loaders
@onready var display_death_chance_skull : Node = $Display/DisplayDeathChanceSkull 





var last_left_cell: BrainCell
var last_right_cell: BrainCell

func _handle_recieve_main_cells(
	main_left_cell: BrainCell,
	main_right_cell: BrainCell
) -> void:

	# Check whether either side actually changed
	var left_changed: bool = main_left_cell != last_left_cell
	var right_changed: bool = main_right_cell != last_right_cell

	# Remember the new cells immediately.
	last_left_cell = main_left_cell
	last_right_cell = main_right_cell


	var has_left_cell: bool = main_left_cell != null
	var has_right_cell: bool = main_right_cell != null


	# Reset active loading timers

	left_death_delay_timer.stop()
	left_blood_delay_timer.stop()
	right_death_delay_timer.stop()
	right_blood_delay_timer.stop()

	left_death_chance_loading_spinner.visible = false
	left_blood_type_loading_spinner.visible = false
	right_death_chance_loading_spinner.visible = false
	right_blood_type_loading_spinner.visible = false


	# Basic visibility

	left_cell_stat_diplay.visible = has_left_cell
	left_no_cell_label.visible = !has_left_cell

	right_cell_stat_diplay.visible = has_right_cell
	right_no_cell_label.visible = !has_right_cell


	# Reset displays

	reset_stat_left._reset()
	reset_death_chance_left._reset()

	reset_stat_right._reset()
	reset_death_chance_right._reset()

	reset_death_chance_skull._reset()


	# Display cells

	if has_left_cell:
		display_stat_left._display_cell(main_left_cell)
		display_death_chance_left._display_cell(main_left_cell)

	if has_right_cell:
		display_stat_right._display_cell(main_right_cell)
		display_death_chance_right._display_cell(main_right_cell)

	# Skull
	display_death_chance_skull._display_cells(main_left_cell, main_right_cell)


	# Start loading only if cell changed

	if left_changed:
		_load_left(main_left_cell)

	if right_changed:
		_load_right(main_right_cell)

func _load_left(cell: BrainCell) -> void:

	if cell == null:
		left_death_chance_display.visible = false
		left_blood_type_display.visible = false
		return

	left_death_chance_display.visible = false
	left_blood_type_display.visible = false

	left_death_chance_loading_spinner.visible = true
	left_blood_type_loading_spinner.visible = true

	left_death_delay_timer.start()
	await left_death_delay_timer.timeout

	# Cell changed/unloaded while waiting
	if cell != last_left_cell:
		return

	left_death_chance_loading_spinner.visible = false
	left_death_chance_display.visible = true

	left_blood_delay_timer.start()
	await left_blood_delay_timer.timeout

	if cell != last_left_cell:
		return

	left_blood_type_loading_spinner.visible = false
	left_blood_type_display.visible = true

func _load_right(cell: BrainCell) -> void:

	if cell == null:
		right_death_chance_display.visible = false
		right_blood_type_display.visible = false
		return

	right_death_chance_display.visible = false
	right_blood_type_display.visible = false

	right_death_chance_loading_spinner.visible = true
	right_blood_type_loading_spinner.visible = true

	right_death_delay_timer.start()
	await right_death_delay_timer.timeout

	# Cell changed/unloaded while waiting
	if cell != last_right_cell:
		return

	right_death_chance_loading_spinner.visible = false
	right_death_chance_display.visible = true

	right_blood_delay_timer.start()
	await right_blood_delay_timer.timeout

	if cell != last_right_cell:
		return

	right_blood_type_loading_spinner.visible = false
	right_blood_type_display.visible = true
