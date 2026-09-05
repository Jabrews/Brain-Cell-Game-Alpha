extends Node

# component handlers 
@onready var handle_cell_seats : Node = $HandleCellSeats
@onready var handle_cycle_stat_btn : Node = $HandleCycleStatBtn
@onready var handle_dissolve : Node = $HandleDissolve
# component helpers
@onready var helper_seat_lights : Node = $HelperSeatLights

# amount to decrease
var strength_amount_to_decrease : int = 0
var intelligence_amount_to_decrease : int = 0
var community_amount_to_decrease : int = 0

# dissolve cells
var strength_dissolve_cell : BrainCell
var intelligence_dissolve_cell : BrainCell
var community_dissolve_cell : BrainCell


# responsible for populating amount to decrease with all cells on queue
# and their selected stats
func _handle_cell_seats_changed() -> void:
	
	# reset amount to decrease
	strength_amount_to_decrease = 0
	intelligence_amount_to_decrease = 0
	community_amount_to_decrease = 0
	
	# get state of seats and stats
	var cell_seats : Dictionary[int, BrainCell] = handle_cell_seats.cell_seats
	var cell_selected_stats : Dictionary[int, String] = handle_cycle_stat_btn.cell_selected_stats
	
	var curr_seat_index : int = 1
	
	# loop through each seat until we hit max
	while curr_seat_index != 5:
		
		var cell : BrainCell = cell_seats[curr_seat_index]
		
		# if not a cell in seat ignore
		if not cell:
			curr_seat_index += 1
			continue
		
		# get corresponding selected stat
		var selected_stat : String = cell_selected_stats[curr_seat_index]
		
		# if none selected dont care
		if selected_stat == "none":
			curr_seat_index += 1
			continue
		
		match selected_stat:
			"strength":
				if cell.strength.enabled:
					strength_amount_to_decrease += int(cell.strength.value)
				
			"intelligence":
				if cell.intelligence.enabled:
					intelligence_amount_to_decrease += int(cell.intelligence.value)
				
			"community":
				if cell.community.enabled:
					community_amount_to_decrease += int(cell.community.value)
				
			"all":
				if cell.strength.enabled:
					strength_amount_to_decrease += int(cell.strength.value)
				
				if cell.intelligence.enabled:
					intelligence_amount_to_decrease += int(cell.intelligence.value)
				
				if cell.community.enabled:
					community_amount_to_decrease += int(cell.community.value)
		
		curr_seat_index += 1
	
	# finally generate dissolve cells
	generate_dissolved_cells(
		cell_seats,
		cell_selected_stats
	)
	
	helper_seat_lights._refresh(cell_seats, cell_selected_stats)
	handle_dissolve._dissolve_cells_changed()
	


# gets one cell that we can apply to a given stat
# one cell can only actively dissolve one stat
func generate_dissolved_cells(
	cell_seats : Dictionary[int, BrainCell],
	cell_selected_stats : Dictionary[int, String]
) -> void:
	
	## FIRST:
	# verify current dissolve cells are still valid
	
	if strength_dissolve_cell:
		if not _verify_dissolve_cell(
			strength_dissolve_cell,
			"strength",
			cell_seats,
			cell_selected_stats
		):
			strength_dissolve_cell = null
	
	if intelligence_dissolve_cell:
		if not _verify_dissolve_cell(
			intelligence_dissolve_cell,
			"intelligence",
			cell_seats,
			cell_selected_stats
		):
			intelligence_dissolve_cell = null
	
	if community_dissolve_cell:
		if not _verify_dissolve_cell(
			community_dissolve_cell,
			"community",
			cell_seats,
			cell_selected_stats
		):
			community_dissolve_cell = null
	
	
	# KEEP TRACK OF CELLS ALREADY BEING USED
	
	var used_cells : Array[BrainCell] = []
	
	if strength_dissolve_cell:
		used_cells.append(strength_dissolve_cell)
	
	if intelligence_dissolve_cell:
		used_cells.append(intelligence_dissolve_cell)
	
	if community_dissolve_cell:
		used_cells.append(community_dissolve_cell)
	
	
	# FIND STRENGTH CELL
	if not strength_dissolve_cell:
		strength_dissolve_cell = _find_dissolve_cell(
			"strength",
			cell_seats,
			cell_selected_stats,
			used_cells
		)
		
		if strength_dissolve_cell:
			used_cells.append(strength_dissolve_cell)
	
	
	# FIND INTELLIGENCE CELL
	if not intelligence_dissolve_cell:
		intelligence_dissolve_cell = _find_dissolve_cell(
			"intelligence",
			cell_seats,
			cell_selected_stats,
			used_cells
		)
		
		if intelligence_dissolve_cell:
			used_cells.append(intelligence_dissolve_cell)
	
	# FIND COMMUNITY CELL
	if not community_dissolve_cell:
		community_dissolve_cell = _find_dissolve_cell(
			"community",
			cell_seats,
			cell_selected_stats,
			used_cells
		)
		
		if community_dissolve_cell:
			used_cells.append(community_dissolve_cell)


# find first valid cell, starting from seat 1
func _find_dissolve_cell(
	stat : String,
	cell_seats : Dictionary[int, BrainCell],
	cell_selected_stats : Dictionary[int, String],
	used_cells : Array[BrainCell]
) -> BrainCell:
	
	var curr_seat_index : int = 1
	
	while curr_seat_index != 5:
		
		var cell : BrainCell = cell_seats[curr_seat_index]
		
		if not cell:
			curr_seat_index += 1
			continue
		
		# already dissolving another stat
		if cell in used_cells:
			curr_seat_index += 1
			continue
		
		var selected_stat : String = cell_selected_stats[curr_seat_index]
		
		# selected stat must either match or be "all"
		if selected_stat != stat and selected_stat != "all":
			curr_seat_index += 1
			continue
		
		# stat must actually be enabled
		if not _is_stat_enabled(cell, stat):
			curr_seat_index += 1
			continue
		
		return cell
	
	return null


# checks whether an existing dissolve cell is still usable
func _verify_dissolve_cell(
	cell : BrainCell,
	stat : String,
	cell_seats : Dictionary[int, BrainCell],
	cell_selected_stats : Dictionary[int, String]
) -> bool:
	
	var curr_seat_index : int = 1
	
	while curr_seat_index != 5:
		
		# found cell still sitting in a seat
		if cell_seats[curr_seat_index] == cell:
			
			var selected_stat : String = cell_selected_stats[curr_seat_index]
			
			if selected_stat != stat and selected_stat != "all":
				return false
			
			if not _is_stat_enabled(cell, stat):
				return false
			
			return true
		
		curr_seat_index += 1
	
	# cell isn't on any seat anymore
	return false


func _is_stat_enabled(cell : BrainCell, stat : String) -> bool:
	
	match stat:
		"strength":
			return cell.strength.enabled
			
		"intelligence":
			return cell.intelligence.enabled
			
		"community":
			return cell.community.enabled
			
		_:
			push_error("Bad stat: ", stat)
			return false
