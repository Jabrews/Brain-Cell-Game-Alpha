
extends Node

# components
@onready var drop_item_parent: Control = $BottomLabelsParent/DropItem
@onready var pickup_item_parent: Control = $BottomLabelsParent/PickupItem
@onready var item_energy_parent: Control = $EnergyLevelParent/ItemEnergyLevel
@onready var item_energy_label: Label = $EnergyLevelParent/ItemEnergyLevel/PanelContainer/ItemEnergyLabel


func _ready() -> void:
	drop_item_parent.visible = false
	item_energy_parent.visible = false

	GLUsableItemBus.connect('useable_item_dropped', _handle_item_dropped)
	GLUsableItemBus.connect('useable_item_picked_up', _handle_item_picked_up)
	GLUsableItemBus.connect('useable_item_used', _handle_item_used)
	GLUsableItemBus.connect('toggle_show_pickup_label', _handle_toggle_show_pickup_label)


func _handle_item_dropped(_useable_item_obj: UseableItemObject) -> void:
	drop_item_parent.visible = false
	item_energy_parent.visible = false


func _handle_item_picked_up(useable_item_obj: UseableItemObject) -> void:
	pickup_item_parent.visible = false
	drop_item_parent.visible = true

	item_energy_parent.visible = useable_item_obj.item_has_energy

	if useable_item_obj.item_has_energy:
		_update_energy_label(useable_item_obj)


func _handle_item_used(item_used_up: bool, useable_item_obj: UseableItemObject) -> void:
	if item_used_up:
		drop_item_parent.visible = false
		item_energy_parent.visible = false
		return

	if useable_item_obj.item_has_energy:
		_update_energy_label(useable_item_obj)


func _handle_toggle_show_pickup_label(toggle_value: bool) -> void:
	pickup_item_parent.visible = toggle_value


func _update_energy_label(useable_item_obj: UseableItemObject) -> void:
	item_energy_label.text = 'Charge Left : ' + str(useable_item_obj.item_energy)
