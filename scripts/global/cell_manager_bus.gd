extends Node

var prisoner_cells_refrence : Array[BrainCell]
var collected_cells_refrence : Array[BrainCell]

# connected
signal prisoner_picked_by_player(prisoner_cell : BrainCell)
signal delete_remaining_prisoners() # called by pris. spawner
signal cell_breeded(old_cell_1 : BrainCell, old_cell_2 : BrainCell, new_collected_cell : BrainCell, boost_left_cell : BrainCell, boost_right_cell : BrainCell, kill_old_1: bool, kill_old_2: bool)

signal delete_selected_collected_cell(collected_cell: BrainCell)
signal hidden_stat_interpreted(selected_cell : BrainCell, selected_stat : String)
signal cell_container_jolt_increase_cell_defect(selected_cell : BrainCell, increase_amount : float)
signal delete_cells_for_next_round()
signal defect_decreaser_used(cell : BrainCell)
signal mutation_frowny_increase_defect(cell : BrainCell)
signal unhide_cell_mutation(cell : BrainCell, mutation : BrainCellMutation)
signal cell_hit_by_crystal(cell : BrainCell)
# this signal is only for rare cases where i just pass in updated cell
# the rest acutally contain the logic in the listner function
signal collected_cell_changed(new_cell : BrainCell)

# emmited
signal cell_deleted(cell_name : String)
signal cell_changed(new_cell : BrainCell)
signal cell_added_to_collection(new_collected_cell : BrainCell)
signal cells_updated()

### DEBUG ###
signal debug_unhide_collected_cell_mutation(selected_cell : BrainCell)
signal debug_create_collected_cells(cells : Array[BrainCell])
