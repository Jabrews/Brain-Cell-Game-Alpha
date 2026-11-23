extends Node

# components
@onready var parent_station_attacher : Node3D = $"../.."
@onready var disabled_hologram_label : Label3D = $"../../Hologram/DisabledLabel"
@onready var hologram_interact_area : Area3D = $"../../Hologram/HologramInteractArea"

func _ready() -> void:
	GLGameManagerBus.connect('process_new_ivs', _handle_process_new_ivs)

func _handle_process_new_ivs() :
	
	if GLWorkstationBus.attacher_enabled == true  : 
		
		# handle hologram
		disabled_hologram_label.visible = false
		hologram_interact_area.set_collision_layer_value(18, true)
		
		
		if parent_station_attacher.enabled == false : 
			
			parent_station_attacher.enabled = true
	
	else : 
		
		# handle hologram
		disabled_hologram_label.visible = true 
		hologram_interact_area.set_collision_layer_value(18, false)

		
		parent_station_attacher.enabled = false 
		
		
