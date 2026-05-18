extends Node

# connected 
signal create_cells(include_target_cell : bool)

# emmited
signal get_newest_target_cell(new_target_cell: BrainCell)
signal get_newest_prisoner_cells(new_prisoner_cells : Array[BrainCell])
