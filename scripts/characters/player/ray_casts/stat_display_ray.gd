extends RayCast3D

var selected_cell_stat_display: Area3D = null
@onready var player_parent: CharacterBody3D = $"../../../.."


func _process(_delta: float) -> void:
	var new_stat_display: Area3D = null

	if is_colliding():
		var collider := get_collider()

		if collider and collider is Area3D:
			if collider.is_in_group("stat_display_area"):
				new_stat_display = collider


	# Nothing changed
	if new_stat_display == selected_cell_stat_display:
		return


	# Turn off old display
	if selected_cell_stat_display:
		selected_cell_stat_display.toggle_display_stat_area(false, null)


	# Store new display
	selected_cell_stat_display = new_stat_display


	# Turn on new display
	if selected_cell_stat_display:
		selected_cell_stat_display.toggle_display_stat_area(
			true,
			player_parent
		)
