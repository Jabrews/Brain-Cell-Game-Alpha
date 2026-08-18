extends Node


var prisoner_picks_energy_used: int = 0
var safe_mode_energy_gained: int = 0

var stat_value_energy_used = {
	'strength': 0,
	'intelligence': 0,
	'community': 0,
}

var spare_symbols_energy_used = {
	'strength': 0,
	'intelligence': 0,
	'community': 0,
}

var current_energy: int = 0
var impending_energy: int = 0

# Prevent normal energy_changed updates from interrupting turn animation
var animating_energy_turn: bool = false


# components
@onready var helper_update_energy_panel: Node = $UpdateEnergyPanel


func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_next_round)
	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_next_turn)
	GLGameManagerBus.connect('energy_changed', _handle_energy_changed)


func _handle_next_round() -> void:

	current_energy = GLGameManagerBus.curr_energy

	reset_energy_used()
	recalculate_impending_energy()


func _handle_next_turn() -> void:

	# Brief await
	await get_tree().create_timer(0.1).timeout

	# Store the energy BEFORE committing the turn.
	var old_current_energy: int = current_energy

	# Calculate the energy after all preview costs.
	recalculate_impending_energy()

	var new_current_energy: int = impending_energy

	# Prevent energy_changed from instantly updating the UI.
	animating_energy_turn = true

	# Commit the new energy.
	GLGameManagerBus.curr_energy = new_current_energy
	current_energy = new_current_energy

	# Reset all preview costs.
	# IMPORTANT: Don't update UI here.
	reset_energy_used(false)

	recalculate_impending_energy()

	# Animate the UI from old → new.
	await helper_update_energy_panel._animate_energy_turn(
		old_current_energy,
		new_current_energy
	)

	# Animation is finished.
	animating_energy_turn = false

	# Make absolutely sure the UI matches the actual state.
	helper_update_energy_panel._update()


# Happens when energy changes elsewhere.
func _handle_energy_changed() -> void:

	current_energy = GLGameManagerBus.curr_energy
	recalculate_impending_energy()

	# Don't instantly update the UI during a turn animation.
	if animating_energy_turn:
		return

	# Normal preview behavior.
	helper_update_energy_panel._update()


func reset_energy_used(update_ui: bool = true) -> void:

	prisoner_picks_energy_used = 0
	safe_mode_energy_gained = 0

	for key in stat_value_energy_used:
		stat_value_energy_used[key] = 0

	for key in spare_symbols_energy_used:
		spare_symbols_energy_used[key] = 0

	if update_ui:
		helper_update_energy_panel._update()


func recalculate_impending_energy() -> void:

	impending_energy = current_energy + get_total_energy_used()


func get_total_energy_used() -> int:

	var total: int = prisoner_picks_energy_used

	total += safe_mode_energy_gained

	for key in stat_value_energy_used:
		total += stat_value_energy_used[key]

	for key in spare_symbols_energy_used:
		total += spare_symbols_energy_used[key]

	return total


func _update_energy_stat_value_used(
	stat_type: String,
	new_value: int
) -> void:

	var value_increment: int = IVPrisonerProfiler.stat_increment_amount
	var energy_decrease_per_increment: int = IVPrisonerProfiler.per_stat_increment_energy_decrease

	@warning_ignore("integer_division")
	var energy_decrease: int = (
		new_value / value_increment
	) * energy_decrease_per_increment

	stat_value_energy_used[stat_type] = -energy_decrease

	recalculate_impending_energy()
	helper_update_energy_panel._update()


func _update_spare_symbol_energy_used(
	stat_type: String,
	new_value: int
) -> void:

	spare_symbols_energy_used[stat_type] = new_value

	recalculate_impending_energy()
	helper_update_energy_panel._update()


func _update_energy_toggle_stat_value_enabled(
	stat_type: String,
	toggle_value: bool,
	last_value: int
) -> void:

	# Turned on
	if toggle_value:
		_update_energy_stat_value_used(stat_type, last_value)
		return

	# Turned off
	match stat_type:
		'strength':
			stat_value_energy_used['strength'] = 2

		'intelligence':
			stat_value_energy_used['intelligence'] = 2

		'community':
			stat_value_energy_used['community'] = 2

	recalculate_impending_energy()
	helper_update_energy_panel._update()


func _update_toggle_safe_mode_active(toggle_value: bool) -> void:

	if toggle_value:
		safe_mode_energy_gained = 10
	else:
		safe_mode_energy_gained = 0

	recalculate_impending_energy()
	helper_update_energy_panel._update()


func _update_energy_player_pressed_prisoner_picks_btn(
	prisoner_picks: int
) -> void:

	if prisoner_picks == 1:
		prisoner_picks_energy_used = -5

	elif prisoner_picks == 2:
		prisoner_picks_energy_used = -10

	else:
		prisoner_picks_energy_used = 0

	recalculate_impending_energy()
	helper_update_energy_panel._update()


func _check_if_energy_valid() -> bool:

	recalculate_impending_energy()

	if impending_energy <= 0:
		return false

	return true
