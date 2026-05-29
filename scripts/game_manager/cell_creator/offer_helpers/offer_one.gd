extends Node


func handle_offer_1(new_prisoner_cells : Array[BrainCell]) :
	if GLShareholderOfferState.offer_1_active :
		if GLShareholderOfferState.display_stat_offer_active_debug_messages :
			print_debug('offer 1')
		# we return 3 not because it is getting farther from org. pos but for the trickery
		var cell_to_delete = new_prisoner_cells.pick_random()
		new_prisoner_cells.erase(cell_to_delete)
	
	return new_prisoner_cells
