extends Node


var showing_cinnamatic : bool = false
signal toggle_showing_cinnamatic(toggle_value : bool)


# indiv cinn.
signal toggle_energy_cinnamatic(toggle_value : bool)

func _ready() -> void:
	toggle_energy_cinnamatic.connect(_handle_toggle_energy_cinnamatic)

func _handle_toggle_energy_cinnamatic(toggle_value : bool) :
	
	if toggle_value : 
		if showing_cinnamatic == true : 
			push_error('trying to show multiple cinnamatics at once')
			return
	
	showing_cinnamatic = toggle_value
		
	
	
