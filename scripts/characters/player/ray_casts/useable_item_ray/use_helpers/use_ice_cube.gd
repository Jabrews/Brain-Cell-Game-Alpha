extends Node


func use(collider : Node3D, held_useable_item_obj : UseableItemObject) :
	

		
	GLPlayerLocalSoundsBus.emit_signal('ice_cube_used')
	
	GLUsableItemBus.emit_signal(
		'use_ice_cube',
		collider.designated_brain_cell,
		held_useable_item_obj
	)

	GLUsableItemBus.emit_signal(
		'useable_item_used',
		true,
		held_useable_item_obj
	)
