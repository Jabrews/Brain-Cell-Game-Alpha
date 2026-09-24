extends Node

# components
@onready var info_mutation_p_s: PackedScene = preload("res://scenes/stations/station_components/cell_breeding/ui/cell_loader/selected_view_slider/information_mutation.tscn" )
@onready var spawn_positions: Array[Control] = [
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/InformationMutations/SpawnPos/Pos1",
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/InformationMutations/SpawnPos/Pos2",
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/InformationMutations/SpawnPos/Pos3",
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/InformationMutations/SpawnPos/Pos4"
]
@onready var info_mutation_parent_node: Control = $"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/InformationMutations/ParentNode"


func _display(cell: BrainCell) -> void:
	
	# clear all prior children
	for info_mutation: Control in info_mutation_parent_node.get_children():
		info_mutation.queue_free()
	
	var index: int = 0
	
	# loop through each mutation
	while index < cell.mutations.size() and index < spawn_positions.size():
		
		var mutation: BrainCellMutation = cell.mutations[index]
		var spawn_pos: Control = spawn_positions[index]
		
		var info_mutation_instance: Control = info_mutation_p_s.instantiate()
		
		info_mutation_parent_node.add_child(info_mutation_instance)
		
		info_mutation_instance.global_position = spawn_pos.global_position
		info_mutation_instance._load_mutation(mutation)
		
		index += 1
