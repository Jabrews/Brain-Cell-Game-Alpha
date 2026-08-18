extends Node


# components
@onready var curr_energy_label: Label3D = $"../../../EnergyBox/CurrentPanel/CurrEnergyLabels/CurrEnergy"
@onready var energy_used_label: Label3D = $"../../../EnergyBox/EnergyPanel/EnergyUsed"
@onready var energy_used_sprite: Sprite3D = $"../../../EnergyBox/EnergyPanel/EnergyIcon2"
@onready var energy_left_label: Label3D = $"../../../EnergyBox/EnergyPanel/EnerfyLeft"

@onready var helper_handle_energy: Node = $".."


func _update() -> void:

	var total = helper_handle_energy.get_total_energy_used()

	curr_energy_label.text = str(GLGameManagerBus.curr_energy)

	handle_update_energy_used(total)

	energy_left_label.text = str(
		GLGameManagerBus.curr_energy + total
	)


func handle_update_energy_used(total: int) -> void:

	if total <= 0:

		energy_used_label.modulate = Color.RED
		energy_used_sprite.modulate = Color.RED

		energy_used_label.text = str(total)

	else:

		energy_used_label.modulate = Color.GREEN
		energy_used_sprite.modulate = Color.GREEN

		energy_used_label.text = '+' + str(total)


func _animate_energy_turn(
	old_current_energy: int,
	new_current_energy: int
) -> void:


	var tween := create_tween()

	# Both labels animate at exactly the same time.
	tween.set_parallel(true)

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	# Current energy:
	# 100 → 84
	tween.tween_method(
		func(value: float) -> void:
			curr_energy_label.text = str(roundi(value)),
		old_current_energy,
		new_current_energy,
		2.0
	)

	# Energy left:
	# Also ends at the new current energy.
	tween.tween_method(
		func(value: float) -> void:
			energy_left_label.text = str(roundi(value)),
		old_current_energy,
		new_current_energy,
		2.0
	)

	await tween.finished

	# Guarantee exact final values.
	curr_energy_label.text = str(new_current_energy)
	energy_left_label.text = str(new_current_energy)
