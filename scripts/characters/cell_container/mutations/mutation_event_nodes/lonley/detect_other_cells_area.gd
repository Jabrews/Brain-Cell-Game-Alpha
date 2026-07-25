
extends Area3D


func _ready() -> void:
	monitoring = false


func flash_check_for_other_cell() -> bool:
	monitoring = true

	# Allow the Area3D overlap data to update.
	await get_tree().physics_frame
	await get_tree().physics_frame

	var cell_container_count: int = 0

	for body: Node3D in get_overlapping_bodies():
		if body.is_in_group("brain_cell_container"):
			cell_container_count += 1

	monitoring = false

	# One is the owning cell container.
	# Two or more means another cell is also inside.
	return cell_container_count >= 2
