extends Node

func handle_offer_3(new_prisoner_cells : Array[BrainCell]) :
	# all cells have no defect but one spider is generated
	# ONESHOT (end after this round)
	if GLShareholderOfferState.offer_3_active	:
		if GLShareholderOfferState.display_stat_offer_active_debug_messages :
			print_debug('offer 3')
		# set defect to 0 in all cells
		for cell : BrainCell in new_prisoner_cells :
			cell.strength_defect = 0
			cell.intelligence_defect = 0
			cell.community_defect = 0
		# pick random cell to become the spider	
		var random_prisoner : BrainCell = new_prisoner_cells.pick_random()
		random_prisoner.turn_into_flesh_bug = true
		print('choose ', random_prisoner.name, ' to become slug bug')
		# after this make sure we turn off active... oneshot
		GLShareholderOfferState.offer_3_active = false
	
	return new_prisoner_cells
