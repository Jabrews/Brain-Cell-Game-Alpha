extends Node

# components
@onready var parent_manager : Node = $".."

func _ready() -> void:
	# unhide
	GLCellManagerBus.connect('unhide_cell_mutation', _handle_unhide_cell_mutation)
	# telekenetic
	GLCellManagerBus.connect('cell_hit_by_crystal', _handle_cell_hiy_by_crystals)
	# lonely
	GLCellManagerBus.connect('mutation_frowny_increase_defect', _handle_mutation_frowny_increase_defect)

func _handle_unhide_cell_mutation(selected_brain_cell : BrainCell, selected_brain_cell_mutation : BrainCellMutation) :
	
	for mutation : BrainCellMutation in selected_brain_cell.mutations : 
		if mutation.name == selected_brain_cell_mutation.name :
			mutation.hidden = false
	
	parent_manager.update_collected_cells([selected_brain_cell])

func _handle_cell_hiy_by_crystals(cell : BrainCell) :
	
	if cell.strength.enabled : 
		cell.strength.defect += 30
	if cell.intelligence.enabled : 
		cell.intelligence.defect += 30
	if cell.community.enabled : 
		cell.community.defect += 30
	
	parent_manager.update_collected_cells([cell])	
	
func _handle_mutation_frowny_increase_defect(selected_cell : BrainCell) : 
	var increase_amount = 40

	selected_cell.strength.defect += increase_amount

	selected_cell.intelligence.defect += increase_amount

	selected_cell.community.defect += increase_amount

	parent_manager.update_collected_cells([selected_cell])
	
