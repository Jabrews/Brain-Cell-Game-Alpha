extends Node

func use(selected_stat :  String , selected_cell :  BrainCell, held_useable_item_obj : UseableItemObject) :


	GLUsableItemBus.emit_signal(
		'use_hidden_shot',
		selected_cell,
		held_useable_item_obj,
		selected_stat,
	)
	
	# increment shot energy downward
	held_useable_item_obj.item_energy -= 1
	
	GLPlayerLocalSoundsBus.emit_signal('sound_shot_used')

	if held_useable_item_obj.item_energy <= 0:

		GLUsableItemBus.emit_signal(
			'useable_item_used',
			true,
			held_useable_item_obj
		)
		
		return true
	
	else:
		
		GLUsableItemBus.emit_signal(
			'useable_item_used',
			false,
			held_useable_item_obj
		)
		
		
		return false

func use_mutation(selected_mutation_type : String, selected_cell : BrainCell, useable_item_obj : UseableItemObject) :
	
	# increment shot energy downward
	useable_item_obj.item_energy -= 1
	
	GLPlayerLocalSoundsBus.emit_signal('sound_shot_used')
	
	GLUsableItemBus.emit_signal(
		'use_hidden_shot_mutation',
		selected_cell,
		useable_item_obj,
		selected_mutation_type,
	)
	
	if useable_item_obj.item_energy <= 0:
		
		GLUsableItemBus.emit_signal(
			'useable_item_used',
			true,
			useable_item_obj
		)
		
		return true
	
	else : 
		GLUsableItemBus.emit_signal(
			'useable_item_used',
			false,
			useable_item_obj
		)
		
		return false
	
