extends Node

# components
@onready var drop_item_label : Label = $DropItemLabel
@onready var item_energy_level_label : Label = $ItemEnergyLevel

func _ready() -> void:
	drop_item_label.visible = false
	GLUsableItemBus.connect('useable_item_dropped', _handle_item_dropped)
	GLUsableItemBus.connect('useable_item_picked_up', _handle_item_picked_up)
	GLUsableItemBus.connect('useable_item_used', _handle_item_used)

func _handle_item_dropped(_useable_item_obj : UseableItemObject) :
	drop_item_label.visible = false
	item_energy_level_label.visible = false
	

func _handle_item_picked_up(useable_item_obj : UseableItemObject) : 
	drop_item_label.visible = true
	if useable_item_obj.item_has_energy :
		item_energy_level_label.visible = true
		item_energy_level_label.text = 'Energy Left : ' + str(useable_item_obj.item_energy)
	

func _handle_item_used(item_used_up : bool, useable_item_obj : UseableItemObject): 
	if item_used_up :
		drop_item_label.visible = false
		item_energy_level_label.visible = false	
	
	if not item_used_up :
		if useable_item_obj.item_has_energy : 
			item_energy_level_label.text = 'Energy Left : ' + str(useable_item_obj.item_energy)
	
	
