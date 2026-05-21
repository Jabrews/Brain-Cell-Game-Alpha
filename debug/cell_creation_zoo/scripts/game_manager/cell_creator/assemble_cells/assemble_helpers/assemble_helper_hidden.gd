extends Node

func _handle_hidden(constructor : CellConstructor, new_prisoners : Array[BrainCell]) :

	# if no stats to hide do nothing
	if len(constructor.stats_to_hide) == 0:
		return new_prisoners

	for stat_to_hide : StatsToHide in constructor.stats_to_hide:
		
		print('selected stat to hide : ', stat_to_hide)

		var stat_items = []

		# create items
		for cell in new_prisoners:

			match stat_to_hide.type:

				'strength':
					stat_items.append({
						'cell': cell,
						'clean_value': cell.strength
					})

				'intelligence':
					stat_items.append({
						'cell': cell,
						'clean_value': cell.intelligence
					})

				'community':
					stat_items.append({
						'cell': cell,
						'clean_value': cell.community
					})
		
		print('items for stat_items')
		for stat_item in stat_items :
			print('cell_name : ', stat_item['cell'].name, ' vale : ', str(stat_item['clean_value']))

		# highest values first
		stat_items.sort_custom(func(a, b):
			return a['clean_value'] > b['clean_value']
		)
		
		print ('items afer sorting : ')
		for stat_item in stat_items :
			print('cell_name : ', stat_item['cell'].name, ' vale : ', str(stat_item['clean_value']))
		
		# optional randomness
		var ran_chance_num = randi_range(0, 100)

		if ran_chance_num >= 75 :

			# only remove if enough cells still remain
			if len(stat_items) > stat_to_hide.quantity :

				stat_items.remove_at(0)

				print('removing first index. list now looks like')
				for stat_item in stat_items :
					print('cell_name : ', stat_item['cell'].name, ' vale : ', str(stat_item['clean_value']))

		# hide top stats
		var max_quantity = stat_to_hide.quantity
		var curr_quantity = 0

		for stat_item in stat_items:

			if curr_quantity >= max_quantity:
				break

			var cell : BrainCell = stat_item['cell']

			match stat_to_hide.type:

				'strength':

					# already hidden
					if cell.strength_hidden :
						continue

					cell.strength_hidden = true

				'intelligence':

					# already hidden
					if cell.intelligence_hidden :
						continue

					cell.intelligence_hidden = true

				'community':

					# already hidden
					if cell.community_hidden :
						continue

					cell.community_hidden = true

			print('hiding stat on cell : ', cell.name)

			curr_quantity += 1

	return new_prisoners
