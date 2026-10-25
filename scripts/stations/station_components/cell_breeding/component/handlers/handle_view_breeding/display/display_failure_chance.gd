extends Node


var failure_chance_parent : Control
var failure_chance_percant_label : Label
var failure_chance_frame : TextureRect


func _display(cell: BrainCell, components: Dictionary) -> void:
	
	
	failure_chance_parent = components['failure_chance_parent']	
	failure_chance_percant_label = components['failure_chance_percant_label']	
	failure_chance_frame = components['failure_chance_frame']	
	
	if cell : 	
		
		
		failure_chance_parent.visible = true
		
		# Get death chance as a percentage
		var total_failure_chance : float = GAMECellBreeder.death_chance_helper._get_total_death_chance(cell, false)
		# Display percentage
		failure_chance_percant_label.text = str(int(total_failure_chance)) + "%"
		# Convert 0-100% to 0.0-1.0 for shader
		var progress: float = total_failure_chance / 100.0
		# set shader
		failure_chance_frame.material.set_shader_parameter("progress", progress)
		
	else :
		failure_chance_parent.visible = false 
			
		
		
		
		
		
	
	
