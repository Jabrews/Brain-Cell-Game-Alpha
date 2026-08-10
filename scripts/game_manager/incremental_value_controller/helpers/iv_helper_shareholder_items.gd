extends Node

@warning_ignore("shadowed_global_identifier")
func _update_shareholder_items(round : int , energy : int) :
	
	if round == 1 :
		GLShareholderOfferState.items_to_offer = [
			UseableOfferItem.new('defect_shot','Decreases a chosen stat on a cell container by 15 percant, 3 charges total' ),
			UseableOfferItem.new('hidden_shot', 'Reveals all hidden stats on a cell container.'),
			UseableOfferItem.new('steroid', 'Increases the clean and defect values of a cell container by 30 percant'),
			UseableOfferItem.new('ice_cube', 'Freezes a cell for one turn. Frozen cells do not age, gain defects, or allow player interaction.'),
			UseableOfferItem.new('scissors', 'Cut off a chosen stat from a cell.'),
		]
	
	elif round == 2 :
		GLShareholderOfferState.items_to_offer = [
			UseableOfferItem.new('defect_shot','Decreases a chosen stat on a cell container by 15 percant, 3 charges total' ),
			UseableOfferItem.new('hidden_shot', 'Reveals all hidden stats on a cell container.'),
			UseableOfferItem.new('steroid', 'Increases the clean and defect values of a cell container by 30 percant'),
			UseableOfferItem.new('ice_cube', 'Freezes a cell for one turn. Frozen cells do not age, gain defects, or allow player interaction.'),
			UseableOfferItem.new('scissors', 'Cut off a chosen stat or mutation from a cell.'),
		]
	
	var danger_level = get_energy_danger_level(energy)
	update_hidden_stat_nax(round, danger_level)
		

func get_energy_danger_level(energy: int) -> int:
	# 75%–100% = 0
	# 50%–75%  = 1
	# 25%–50%  = 2
	# 0%–25%   = 3

	var max_energy: int = GLGameManagerBus.max_energy
	var energy_percent: float = float(energy) / float(max_energy)

	if energy_percent >= 0.75:
		return 0
	elif energy_percent >= 0.50:
		return 1
	elif energy_percent >= 0.25:
		return 2
	else:
		return 3
	
@warning_ignore("shadowed_global_identifier")
func update_hidden_stat_nax(round : int, danger_level : int) :
	
	if round == 1 :
		match danger_level :
			0 :
				pass
			1 :
				pass
			2 :
				pass
			3 :
				pass
	
	elif round == 2 :
		match danger_level :
			0 :
				pass
			1 :
				pass
			2 :
				pass
			3 :
				pass
	
