extends Node

# components 
@onready var parent_manager : Node = $".."

func _ready() -> void:
	# breeder
	GLCellManagerBus.connect('cell_breeded', _handle_cell_breeded)
	# hidden interpreter
	GLCellManagerBus.connect('hidden_stat_interpreted', _handle_hidden_stat_interpreted)
	GLCellManagerBus.connect('cell_container_jolt_increase_cell_defect', _handle_cell_container_jolt_increase_cell_defect)
	# defect decreaser
	GLCellManagerBus.connect('defect_decreaser_used', _handle_defect_decreaser_used)

func _handle_cell_breeded(
	old_cell_1: BrainCell,
	old_cell_2: BrainCell,
	_new_cell: BrainCell, # unused. cell char creates
	boost_cell_1: BrainCell,
	boost_cell_2: BrainCell,
	kill_old_1: bool,
	kill_old_2: bool
) -> void:
	var cells_to_delete: Array[BrainCell] = []
	var cells_to_update: Array[BrainCell] = []

	if kill_old_1:
		cells_to_delete.append(old_cell_1)
	else:
		cells_to_update.append(old_cell_1)

	if kill_old_2:
		cells_to_delete.append(old_cell_2)
	else:
		cells_to_update.append(old_cell_2)

	# Delete old cells before updating the surviving and boosted cells.
	if not cells_to_delete.is_empty():
		parent_manager.delete_collected_cells(cells_to_delete)

	if boost_cell_1:
		cells_to_update.append(boost_cell_1)

	if boost_cell_2:
		cells_to_update.append(boost_cell_2)

	if not cells_to_update.is_empty():
		parent_manager.update_collected_cells(cells_to_update)

func _handle_hidden_stat_interpreted(selected_cell : BrainCell, selected_stat : String) :
	
	match selected_stat :
		'strength' :
			selected_cell.strength.hidden = false
		'intelligence' :
			selected_cell.intelligence.hidden = false
		'community' :
			selected_cell.community.hidden = false
		
	parent_manager.update_collected_cells([selected_cell])

func _handle_cell_container_jolt_increase_cell_defect(selected_cell : BrainCell, increase_amount : float) :
	
		if selected_cell.strength.enabled :
			selected_cell.strength.defect += increase_amount 
		if selected_cell.intelligence.enabled :
			selected_cell.intelligence.defect += increase_amount 
		if selected_cell.community.enabled :
			selected_cell.community.defect += increase_amount 
	
		parent_manager.update_collected_cells([selected_cell])
	
func _handle_defect_decreaser_used(selected_brain_cell : BrainCell) :

	var decrease_amount = IVCellDefectDecreaser.decrease_amount

	selected_brain_cell.strength.defect = max( 0.0, selected_brain_cell.strength.defect - decrease_amount)

	selected_brain_cell.intelligence.defect = max( 0.0, selected_brain_cell.intelligence.defect - decrease_amount)

	selected_brain_cell.community.defect = max( 0.0, selected_brain_cell.community.defect - decrease_amount)

	parent_manager.update_collected_cells([selected_brain_cell])
