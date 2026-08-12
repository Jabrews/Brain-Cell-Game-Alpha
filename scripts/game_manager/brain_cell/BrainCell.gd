class_name BrainCell

var name: String

var mutations: Array[BrainCellMutation] = []

var strength: BrainCellStat
var intelligence: BrainCellStat
var community: BrainCellStat

var life_span: int

var is_target_cell: bool
var turn_into_flesh_bug: bool
var cell_is_frozen: bool


@warning_ignore("shadowed_variable")
func _init(
	name: String,
	mutations: Array[BrainCellMutation],
	strength: BrainCellStat,
	intelligence: BrainCellStat,
	community: BrainCellStat,
	life_span: int,
	is_target_cell: bool = false,
	turn_into_flesh_bug: bool = false,
	cell_is_frozen: bool = false,
) -> void:
	self.name = name
	self.mutations = mutations

	self.strength = strength
	self.intelligence = intelligence
	self.community = community

	self.life_span = life_span
	self.is_target_cell = is_target_cell
	self.turn_into_flesh_bug = turn_into_flesh_bug
	self.cell_is_frozen = cell_is_frozen


func get_stat(stat_type: String) -> BrainCellStat:
	match stat_type:
		"strength":
			return strength
		"intelligence":
			return intelligence
		"community":
			return community
		_:
			push_error("Invalid stat_type: " + stat_type)
			return null


func copy() -> BrainCell:
	var mutation_copies: Array[BrainCellMutation] = []

	for mutation: BrainCellMutation in mutations:
		if mutation == null:
			continue

		mutation_copies.append(
			BrainCellMutation.new(
				mutation.type,
				mutation.hidden,
			)
		)

	var copied_cell := BrainCell.new(
		name,
		mutation_copies,
		_copy_stat(strength),
		_copy_stat(intelligence),
		_copy_stat(community),
		life_span,
		is_target_cell,
		turn_into_flesh_bug,
		cell_is_frozen,
	)

	return copied_cell


func _copy_stat(stat: BrainCellStat) -> BrainCellStat:
	if stat == null:
		return null

	return BrainCellStat.new(
		stat.type,
		stat.enabled,
		stat.value,
		stat.defect,
		stat.hidden,
	)


func _to_string() -> String:
	@warning_ignore("incompatible_ternary")
	return (
		"[BrainCell] %s | mutations: %s"
		+ " | STR: %s enabled: %s defect: %s hidden: %s"
		+ " | INT: %s enabled: %s defect: %s hidden: %s"
		+ " | COM: %s enabled: %s defect: %s hidden: %s"
		+ " | lifespan: %s"
	) % [
		name,
		mutations,

		strength.value if strength else "NULL",
		strength.enabled if strength else "NULL",
		strength.defect if strength else "NULL",
		strength.hidden if strength else "NULL",

		intelligence.value if intelligence else "NULL",
		intelligence.enabled if intelligence else "NULL",
		intelligence.defect if intelligence else "NULL",
		intelligence.hidden if intelligence else "NULL",

		community.value if community else "NULL",
		community.enabled if community else "NULL",
		community.defect if community else "NULL",
		community.hidden if community else "NULL",

		life_span,
	]
