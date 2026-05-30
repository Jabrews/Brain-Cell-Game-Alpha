extends Node

func use(collider : Node3D, held_useable_item_obj : UseableItemObject) :

	GLPlayerLocalSoundsBus.emit_signal('sound_pills_used')
	
	GLUsableItemBus.emit_signal(
		'use_steroid',
		collider.designated_brain_cell,
		held_useable_item_obj
	)

	GLUsableItemBus.emit_signal(
		'useable_item_used',
		true,
		held_useable_item_obj
	)
