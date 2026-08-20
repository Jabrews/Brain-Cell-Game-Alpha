extends Node


# indiv cinn.
signal toggle_energy_cinnamatic(toggle_value : bool)
var showing_energy_cinnamatic : bool = false

signal toggle_extractor_cinnamatic(toggle_value : bool)


func _ready() -> void:
	toggle_energy_cinnamatic.connect(_on_toggle_energy_cinnamatic)	
	
func _on_toggle_energy_cinnamatic(toggle_value : bool) : 
	if showing_energy_cinnamatic : 	
		if toggle_value : 
			push_error('trying to toggle energy cinnamatic twice')
			return
	
	showing_energy_cinnamatic = toggle_value
		
	
	
	
	
	
	
	

		
	
	
