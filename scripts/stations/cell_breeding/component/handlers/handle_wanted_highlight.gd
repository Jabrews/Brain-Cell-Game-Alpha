extends Node



func _handle(last_ui_state: Dictionary[String, BrainCell]) -> void:
	
	var panel_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_panel_state.duplicate()
	var ui_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_ui_state.duplicate()
	
	# 1. look at prior ui state
	# if a cell existed before but is no longer in current ui,
	# remove its designated border
	
	
	# 2. look through CURRENT ui and panel state
	# if cell exists in both, remove designated border
	# if cell only exists in ui, show designated border
	
	# 3. make sure box borders follow the same wanted / not wanted state
