extends Node

var round_1 : Round1CellConstructors

func _ready() -> void:
	round_1 = Round1CellConstructors.new()

@warning_ignore("shadowed_global_identifier")
func get_cell_constructor(round : int, turn : int) -> Array[CellConstructor]:
	
	var constructors : Array[CellConstructor]

	match round:
		1:
			if turn == 0 :
				constructors = round_1.turn_1
			if turn == 1 :
				constructors = round_1.turn_1
			elif turn == 2 : 
				constructors = round_1.turn_2
			elif turn == 3: 
				constructors = round_1.turn_3
			elif turn == 4 :
				constructors = round_1.turn_4

	return constructors
