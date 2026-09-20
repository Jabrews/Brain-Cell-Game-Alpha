extends Node


var death_chance_parent : Control
var death_chance_percant_label : Label
var death_chance_frame : TextureRect


func _display(cell: BrainCell, components: Dictionary) -> void:
	
	
	death_chance_parent = components['death_chance_parent']	
	death_chance_percant_label = components['death_chance_percant_label']	
	death_chance_frame = components['death_chance_frame']	
	
	if cell : 	
		
		
		death_chance_parent.visible = true
		
		# Get death chance as a percentage
		var total_death_chance: float = GAMECellBreeder.death_chance_helper._get_total_death_chance(cell, false)
		# Display percentage
		death_chance_percant_label.text = str(int(total_death_chance)) + "%"
		# Convert 0-100% to 0.0-1.0 for shader
		var progress: float = total_death_chance / 100.0
		# set shader
		death_chance_frame.material.set_shader_parameter("progress", progress)
		
	else :
		
		
		death_chance_parent.visible = false 
			
		
		
		
		
		
	
	
