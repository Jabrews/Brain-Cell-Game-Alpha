extends Node

# stat type symbols components
@onready var checkmark_symbols : Array[Control] = [
	$"../../AcceptCell/BonusSymbols/CheckmarkSymbols/StrengthCheckMark",
	$"../../AcceptCell/BonusSymbols/CheckmarkSymbols/IntelligenceCheckMark",
	$"../../AcceptCell/BonusSymbols/CheckmarkSymbols/CommunityCheckMark"
]
@onready var invalid_symbols : Array[Control] = [
	$"../../AcceptCell/BonusSymbols/InvalidSymbols/StrengthInvalid",
	$"../../AcceptCell/BonusSymbols/InvalidSymbols/IntelligenceInvalid",
	$"../../AcceptCell/BonusSymbols/InvalidSymbols/CommunityInvalid"
]

# bonus parent components
@onready var applied_parent : Control = $"../../AcceptCell/Footer/TriadBonous/AppliedParent"
@onready var failed_parent : Control = $"../../AcceptCell/Footer/TriadBonous/FailedParent"

var stats : Array[String] = ['strength', 'intelligence', 'community']

func _display_stat_type_symbol(threshold_stat : ThresholdStat, elevator_cell_stat : BrainCellStat) : 
	
	var stat_index : int = stats.find(elevator_cell_stat.type)
	
	# get corrisponding symbols
	var checkmark_symbol : Control = checkmark_symbols[stat_index]
	var invalid_symbol : Control = invalid_symbols[stat_index]
	
	checkmark_symbol.visible = false
	invalid_symbol.visible = false
	
	if threshold_stat.disabled or threshold_stat.finished: 
		return
	
	# stat disabled or hidden
	if not elevator_cell_stat.enabled or elevator_cell_stat.hidden : 
		invalid_symbol.visible = true
		return
	
	# amount_to_decrease / defect ignore
	if elevator_cell_stat.value <= elevator_cell_stat.defect : 
		invalid_symbol.visible = true
		return
	
	checkmark_symbol.visible = true
	

func _display_validity_label(
	threshold_piece: ThresholdPiece,
	elevator_cell: BrainCell
) -> void:
	var bonus_is_valid: bool = true
	var included_stat_count: int = 0

	for threshold_stat: ThresholdStat in threshold_piece.get_stats():
		if threshold_stat.disabled or threshold_stat.finished:
			continue

		included_stat_count += 1

		var cell_stat: BrainCellStat = elevator_cell.get_stat(
			threshold_stat.type
		)

		if not _is_stat_valid_for_bonus(cell_stat):
			bonus_is_valid = false
			break

	if included_stat_count == 0:
		bonus_is_valid = false

	applied_parent.visible = bonus_is_valid
	failed_parent.visible = not bonus_is_valid


func _is_stat_valid_for_bonus(cell_stat: BrainCellStat) -> bool:
	if cell_stat == null:
		return false

	return (
		cell_stat.enabled
		and not cell_stat.hidden
		and cell_stat.value > cell_stat.defect
	)
