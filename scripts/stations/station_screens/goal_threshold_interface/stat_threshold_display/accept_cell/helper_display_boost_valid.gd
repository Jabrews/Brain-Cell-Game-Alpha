extends Node

# Main stat symbols
@onready var checkmark_symbols: Array[Control] = [
	$"../../AcceptCell/BonusSymbols/CheckmarkSymbols/StrengthCheckMark",
	$"../../AcceptCell/BonusSymbols/CheckmarkSymbols/IntelligenceCheckMark",
	$"../../AcceptCell/BonusSymbols/CheckmarkSymbols/CommunityCheckMark"
]

@onready var invalid_symbols: Array[Control] = [
	$"../../AcceptCell/BonusSymbols/InvalidSymbols/StrengthInvalid",
	$"../../AcceptCell/BonusSymbols/InvalidSymbols/IntelligenceInvalid",
	$"../../AcceptCell/BonusSymbols/InvalidSymbols/CommunityInvalid"
]

# Footer hint symbols
@onready var symbol_hint_checkmark_symbols: Array[TextureRect] = [
	$"../../AcceptCell/Footer/TriadBonous/SymbolHintParent/Strength/CheckMarkSymbol",
	$"../../AcceptCell/Footer/TriadBonous/SymbolHintParent/Intelligence/CheckMarkSymbol",
	$"../../AcceptCell/Footer/TriadBonous/SymbolHintParent/Community/CheckMarkSymbol"
]

@onready var symbol_hint_invalid_symbols: Array[TextureRect] = [
	$"../../AcceptCell/Footer/TriadBonous/SymbolHintParent/Strength/InvalidSymbol",
	$"../../AcceptCell/Footer/TriadBonous/SymbolHintParent/Intelligence/InvalidSymbol",
	$"../../AcceptCell/Footer/TriadBonous/SymbolHintParent/Community/InvalidSymbol"
]

# Bonus status parents
@onready var applied_parent: Control = $"../../AcceptCell/Footer/TriadBonous/AppliedParent"
@onready var failed_parent: Control = $"../../AcceptCell/Footer/TriadBonous/FailedParent"

var stats: Array[String] = [
	"strength",
	"intelligence",
	"community"
]


func _display_stat_type_symbol(
	threshold_stat: ThresholdStat,
	elevator_cell_stat: BrainCellStat
) -> void:
	var stat_index: int = stats.find(elevator_cell_stat.type)

	if stat_index == -1:
		push_warning("Unknown stat type: " + elevator_cell_stat.type)
		return

	var checkmark_symbol: Control = checkmark_symbols[stat_index]
	var invalid_symbol: Control = invalid_symbols[stat_index]
	var hint_checkmark: TextureRect = symbol_hint_checkmark_symbols[stat_index]
	var hint_invalid: TextureRect = symbol_hint_invalid_symbols[stat_index]

	# Hide all symbols before deciding which ones to show.
	checkmark_symbol.visible = false
	invalid_symbol.visible = false
	hint_checkmark.visible = false
	hint_invalid.visible = false

	# Disabled or completed threshold stats don't show a symbol.
	if threshold_stat.disabled or threshold_stat.finished:
		return

	var stat_is_valid: bool = _is_stat_valid_for_bonus(elevator_cell_stat)

	if stat_is_valid:
		checkmark_symbol.visible = true
		hint_checkmark.visible = true
	else:
		invalid_symbol.visible = true
		hint_invalid.visible = true


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
