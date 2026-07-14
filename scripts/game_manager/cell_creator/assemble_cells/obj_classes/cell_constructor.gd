extends Node

class_name CellConstructor

var cell_quantity : int
var prisoner_picks  : int

var strength : StatConstructor
var intelligence : StatConstructor
var community : StatConstructor


@warning_ignore("shadowed_variable")
func _init(
	cell_quantity : int,
	prisoner_picks :int,
	strength : StatConstructor,
	intelligence : StatConstructor,
	community : StatConstructor
) -> void:

	self.cell_quantity = cell_quantity
	self.prisoner_picks = prisoner_picks

	self.strength = strength
	self.intelligence = intelligence
	self.community = community


func _to_string() -> String:
	return "[CellConstructor: quantity=%s, prisoner_picks=%s, hidden_stat_quantity=%s, strength=%s, intelligence=%s, community=%s]" % [
		cell_quantity,
		prisoner_picks,
		strength,
		intelligence,
		community
	]
