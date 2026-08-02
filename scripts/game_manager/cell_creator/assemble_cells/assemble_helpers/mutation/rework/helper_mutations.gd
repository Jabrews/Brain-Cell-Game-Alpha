extends Node


func _handle_create_mutations(
	cell_constructor: CellConstructor,
	prisoner_cells: Array[BrainCell],
	stat_constructors: Array[StatConstructor],
) -> Array[BrainCell] :
	
	
	
	
	
	
	
	
	return []

func get_energy_range() -> int  :
	var max_energy : float = GLGameManagerBus.max_energy
	var curr_energy: float = GLGameManagerBus.curr_energy

	if max_energy <= 0.0:
		return 0

	var energy_percent: float = curr_energy / max_energy

	# Split energy into three equal ranges.
	if energy_percent >= 2.0 / 3.0:
		return 0 # High energy
	elif energy_percent >= 1.0 / 3.0:
		return 1 # Medium energy
	else:
		return 2 # Low energy
