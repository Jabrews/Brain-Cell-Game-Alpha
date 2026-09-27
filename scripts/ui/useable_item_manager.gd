extends Node

# components
@onready var drop_item_parent : Control = $DropItem
@onready var pickup_item_parent : Control = $PickupItem
@onready var item_energy_level_parent : Control = $ItemEnergyLevel
@onready var item_energy_label : Label = $ItemEnergyLevel/ItemEnergyLabel

func _ready() -> void:
	drop_item_parent.visible = false
	GLUsableItemBus.connect('useable_item_dropped', _handle_item_dropped)
	GLUsableItemBus.connect('useable_item_picked_up', _handle_item_picked_up)
	GLUsableItemBus.connect('useable_item_used', _handle_item_used)
	GLUsableItemBus.connect('toggle_show_pickup_label', _handle_toggle_show_pickup_label)

func _handle_item_dropped(_useable_item_obj : UseableItemObject) :
	drop_item_parent.visible = false
	item_energy_level_parent.visible = false
	

func _handle_item_picked_up(useable_item_obj : UseableItemObject) : 
	
	# hide pickup label	
	pickup_item_parent.visible = false
	
	drop_item_parent.visible = true
	
	if useable_item_obj.item_has_energy :
		item_energy_level_parent.visible = true
		item_energy_label.text = 'Charge Left : ' + str(useable_item_obj.item_energy)
		
		
	

func _handle_item_used(item_used_up : bool, useable_item_obj : UseableItemObject): 
	if item_used_up :
		drop_item_parent.visible = false
		item_energy_level_parent.visible = false	
	
	if not item_used_up :
		if useable_item_obj.item_has_energy : 
			item_energy_label.text = 'Charge Left : ' + str(useable_item_obj.item_energy)
	
func _handle_toggle_show_pickup_label(toggle_value : bool) :	
	pickup_item_parent.visible = toggle_value
