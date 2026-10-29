extends Node

# components
@onready var parent_station : Node3D = $".."
@onready var handle_dissolving : Node = $"../HandleDissolving"

var dissolving_cell : DissolvingCell

func _create_inital_dissolving_cell(active_threshold_piece : ThresholdPiece) :
	
	dissolving_cell = DissolvingCell.new(
		null, # corrisponding cell
		DissolvingStat.new('strength', 0, 0, active_threshold_piece.strength, false),
		DissolvingStat.new('intelligence', 0, 0, active_threshold_piece.intelligence, false), # (value/amount to decrease, defect)
		DissolvingStat.new('community', 0, 0, active_threshold_piece.community, false),
	)
	
	handle_dissolving._refresh()

func _create_dissolving_cell(elevator_cell_container: CharacterBody3D) :
	
	if not elevator_cell_container:
		push_error('trying to create dissolve cell without elevator cell')
		return
	
	var active_threshold_piece : ThresholdPiece = parent_station.active_threshold_piece
	
	elevator_cell_container.spawn_flesh_bug_on_death = false
	
	var elevator_cell : BrainCell = elevator_cell_container.designated_brain_cell
	
	# qucick aside for finding stats to not include for dissolved cell creation
	# kinda hacky
	var strength_valid : bool = not elevator_cell.strength.hidden and elevator_cell.strength.enabled
	var intelligence_valid : bool = not elevator_cell.strength.hidden and elevator_cell.strength.enabled
	var community_valid : bool = not elevator_cell.strength.hidden and elevator_cell.strength.enabled
	
	dissolving_cell = DissolvingCell.new(
		elevator_cell,
		DissolvingStat.new('strength', elevator_cell.strength.value, elevator_cell.strength.defect, active_threshold_piece.strength, strength_valid),
		DissolvingStat.new('intelligence', elevator_cell.intelligence.value, elevator_cell.intelligence.defect, active_threshold_piece.intelligence, intelligence_valid),
		DissolvingStat.new('community', elevator_cell.community.value, elevator_cell.community.defect, active_threshold_piece.community, community_valid),
	)
	
	## ALL STAT BONUS ##
	var all_stat_bonus_active : bool = decide_all_stat_bonus(dissolving_cell)
	
	if all_stat_bonus_active :
		dissolving_cell = apply_all_stat_bonus()
	####################

	handle_dissolving._refresh()
	
	GLCellManagerBus.emit_signal('delete_selected_collected_cell', elevator_cell)
		
func decide_all_stat_bonus(dissolve_cell: DissolvingCell) -> bool:
	
	if dissolve_cell == null:
		return false

	var active_threshold_piece: ThresholdPiece = parent_station.active_threshold_piece
	
	if active_threshold_piece == null:
		return false

	var threshold_stats_included: Array[String] = []

	## get included threshold stats ##
	for threshold_stat in active_threshold_piece.get_stats():
		# stat isnt disabled or completed
		if not threshold_stat.disabled or threshold_stat.finished:
			threshold_stats_included.append(threshold_stat.type)

	if threshold_stats_included.is_empty():
		push_error('unable to find any included threshold stats')
		return false

	var dissolving_stats: Array[DissolvingStat] = dissolve_cell.get_stats()

	for threshold_stat_type: String in threshold_stats_included:
		var corresponding_dissolve_stat: DissolvingStat = null

		for dissolving_stat: DissolvingStat in dissolving_stats:
			
			if dissolving_stat.stat_type == threshold_stat_type:
				corresponding_dissolve_stat = dissolving_stat
				break

		if corresponding_dissolve_stat == null:
			return false
		
		# if stat is hidden or disabled includes this
		if not corresponding_dissolve_stat.dissolve_valid :
			return false

		# finale check to verify this stat is valud
		if corresponding_dissolve_stat.amount_to_decrease <= corresponding_dissolve_stat.defect_ignore :
			return false

	return true
		
	
func apply_all_stat_bonus() -> DissolvingCell :
	
	dissolving_cell.all_stats_bonus = true
	
	var strength_stat : DissolvingStat = dissolving_cell.strength_dissolving_stat
	var intelligence_stat : DissolvingStat = dissolving_cell.intelligence_dissolving_stat
	var community_stat : DissolvingStat= dissolving_cell.community_dissolving_stat
	
	if strength_stat.amount_to_decrease > strength_stat.defect_ignore :
		
		if strength_stat.dissolve_valid :
			strength_stat.amount_to_decrease += strength_stat.amount_to_decrease * 1.0
		
	if intelligence_stat.amount_to_decrease > intelligence_stat.defect_ignore :
		
		if intelligence_stat.dissolve_valid :
			intelligence_stat.amount_to_decrease += intelligence_stat.amount_to_decrease * 1.0
	
	if community_stat.amount_to_decrease > community_stat.defect_ignore :
		
		if community_stat.dissolve_valid :
			community_stat.amount_to_decrease += community_stat.amount_to_decrease * 1.0
		
	return dissolving_cell
	
