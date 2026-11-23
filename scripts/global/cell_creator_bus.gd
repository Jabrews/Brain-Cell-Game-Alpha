extends Node

# connected 
signal create_prisoner_cells(cell_constructor : CellConstructor)

# emmited
signal get_newest_prisoner_cells(new_prisoner_cells : Array[BrainCell])
