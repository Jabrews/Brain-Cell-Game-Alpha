extends Area3D

@onready var parent_mutation_mesh: Node3D = $"../../MutationMeshParent"
@onready var parent_stat_display : Node3D = $"../.."

func _toggle_disrupt_manager(toggle_value: bool) -> void:
	
	var disrupt_managers: Array[Node] = get_manager_nodes()
	
	for disrupt_manager: Node in disrupt_managers:
		disrupt_manager._display_interuption(toggle_value)


func get_manager_nodes() -> Array[Node]:
	var disrupt_managers: Array[Node] = []

	for mutation_mesh: Node in parent_mutation_mesh.get_children():

		# Go into SubViewport
		for subviewport: Node in mutation_mesh.get_children():

			# Go into screen
			for screen_node: Node in subviewport.get_children():

				if not screen_node.name.contains("Screen"):
					continue

				# Find disruptor manager
				for child: Node in screen_node.get_children():
					if (
						child.name.contains("Manager")
						and child.name.contains("Disruptor")
					):
						disrupt_managers.append(child)

	return disrupt_managers

			
			
			
			
