extends Node


func use_stat(selected_stat : String, selected_cell : BrainCell, useable_item_obj : UseableItemObject) :
	
	GLPlayerLocalSoundsBus.emit_signal('scissors_used')
	
	GLUsableItemBus.emit_signal(
		'use_scissors_stat',
		selected_cell,
		useable_item_obj,
		selected_stat,
	)

	GLUsableItemBus.emit_signal(
		'useable_item_used',
		true,
		useable_item_obj
	)

func use_mutation(selected_mutation_type : String, selected_cell : BrainCell, useable_item_obj : UseableItemObject) :
	
	GLPlayerLocalSoundsBus.emit_signal('scissors_used')
	
	GLUsableItemBus.emit_signal(
		'use_scissors_mutation',
		selected_cell,
		useable_item_obj,
		selected_mutation_type,
	)

	GLUsableItemBus.emit_signal(
		'useable_item_used',
		true,
		useable_item_obj
	)
