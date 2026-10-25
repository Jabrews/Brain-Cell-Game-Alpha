extends Node

var prisoner_cells_refrence : Array[BrainCell]
var collected_cells_refrence : Array[BrainCell]

## Core
# delete
signal delete_remaining_prisoners() # called by pris. spawner
signal delete_selected_collected_cell(collected_cell: BrainCell)
signal delete_cells_for_next_goal_piece()
# change / create
signal create_prisoner_cells(prisoner_cells : Array[BrainCell])
signal collected_cell_created(cell : BrainCell) # called when brain container initalizes
signal prisoner_picked_by_player(prisoner_cell : BrainCell)
signal collected_cell_changed(new_cell : BrainCell)

## Mutation Events
# unhide
signal unhide_cell_mutation(cell : BrainCell, mutation : BrainCellMutation)
# telekenetic
signal cell_hit_by_crystal(cell : BrainCell)
# lonley
signal mutation_frowny_increase_defect(cell : BrainCell)

## Station Events
# breeder
signal cell_breeded(old_cell_1 : BrainCell, old_cell_2 : BrainCell, new_collected_cell : BrainCell, boost_left_cell : BrainCell, boost_right_cell : BrainCell, kill_old_1: bool, kill_old_2: bool)
# hidden interpreter
signal hidden_stat_interpreted(selected_cell : BrainCell, selected_stat : String)
signal cell_container_jolt_increase_cell_defect(selected_cell : BrainCell, increase_amount : float)
# defect decreaser
signal defect_decreaser_used(cell : BrainCell)

# emmited
signal cell_deleted(cell_name : String)
signal cell_changed(new_cell : BrainCell)
# adds to pris extractor and lock
signal cell_added_to_collection(new_collected_cell : BrainCell)
signal cells_updated()

### DEBUG ###
signal debug_unhide_collected_cell_mutation(selected_cell : BrainCell)
signal debug_create_collected_cells(cells : Array[BrainCell])
signal toggle_lock_cell_pickup(cell_name : String, toggle_value : bool)
