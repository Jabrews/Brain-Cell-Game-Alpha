extends Node


@warning_ignore("shadowed_global_identifier")
func _update_shareholder_items(round: int, goal_piece: int) -> void:
	
	if round == 1:
		GLShareholderOfferState.items_to_offer = [
			UseableOfferItem.new(
				"defect_shot",
				"Decreases a chosen stat on a cell container by 15 percent, 3 charges total."
			),
			UseableOfferItem.new(
				"hidden_shot",
				"Reveals all hidden stats on a cell container."
			),
			UseableOfferItem.new(
				"steroid",
				"Increases the clean and defect values of a cell container by 30 percent."
			),
			UseableOfferItem.new(
				"ice_cube",
				"Freezes a cell for one turn. Frozen cells do not age, gain defects, or allow player interaction."
			),
			UseableOfferItem.new(
				"scissors",
				"Cut off a chosen stat from a cell."
			),
		]
	
	elif round == 2:
		GLShareholderOfferState.items_to_offer = [
			UseableOfferItem.new(
				"defect_shot",
				"Decreases a chosen stat on a cell container by 15 percent, 3 charges total."
			),
			UseableOfferItem.new(
				"hidden_shot",
				"Reveals all hidden stats on a cell container."
			),
			UseableOfferItem.new(
				"steroid",
				"Increases the clean and defect values of a cell container by 30 percent."
			),
			UseableOfferItem.new(
				"ice_cube",
				"Freezes a cell for one turn. Frozen cells do not age, gain defects, or allow player interaction."
			),
			UseableOfferItem.new(
				"scissors",
				"Cut off a chosen stat or mutation from a cell."
			),
		]
	
	update_shareholder_item_progression(round, goal_piece)


@warning_ignore("shadowed_global_identifier")
func update_shareholder_item_progression(round: int, goal_piece: int) -> void:
	
	if round == 1:
		match goal_piece:
			1:
				pass
			2:
				pass
			3:
				pass
			4:
				pass
	
	elif round == 2:
		match goal_piece:
			1:
				pass
			2:
				pass
			3:
				pass
			4:
				pass
