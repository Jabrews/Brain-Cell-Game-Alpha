extends RefCounted

class_name GoalThreshold


var active_piece_index : int
var pieces : Dictionary[int, ThresholdPiece]


func _init(
	starting_piece_index : int = 0,
	new_pieces : Dictionary[int, ThresholdPiece] = {},
) -> void:
	
	active_piece_index = starting_piece_index
	pieces = new_pieces


func get_active_piece() -> ThresholdPiece:
	
	if not pieces.has(active_piece_index):
		push_error("GoalThreshold has no piece at index: " + str(active_piece_index))
		return null
	
	return pieces[active_piece_index]


func advance_piece() -> void:
	active_piece_index += 1


func is_finished() -> bool:
	return not pieces.has(active_piece_index)


func print_info() -> void:
	print("====== GOAL THRESHOLD ======")
	print("Active Piece Index: ", active_piece_index)
	print("Total Pieces: ", pieces.size())
	print("Finished: ", is_finished())
	
	for piece_index : int in pieces:
		print("")
		print("Piece Index: ", piece_index)
		pieces[piece_index].print_info()
	
	print("============================")
