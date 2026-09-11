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

var breeder_unavaible : bool


@warning_ignore("shadowed_variable")
func _init(
	name: String,
	mutations: Array[BrainCellMutation],
	strength: BrainCellStat,
	intelligence: BrainCellStat,
	community: BrainCellStat,
	life_span: int,
	cell_is_frozen: bool = false,
	breeder_unavaible : bool = false
) -> void:
	self.name = name
	self.mutations = mutations

	self.strength = strength
	self.intelligence = intelligence
	self.community = community

	self.life_span = life_span
	self.cell_is_frozen = cell_is_frozen
	
	self.breeder_unavaible = breeder_unavaible


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
	return "%s | can breed: %s" % [
		name,
		not breeder_unavaible
	]
