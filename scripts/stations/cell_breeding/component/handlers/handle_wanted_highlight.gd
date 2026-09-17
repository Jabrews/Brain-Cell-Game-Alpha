extends Node


func _handle(last_ui_state: Dictionary[String, BrainCell]) -> void:
	
	var panel_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_panel_state.duplicate()
	var ui_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_ui_state.duplicate()
	
	# 1. look at prior ui state
	# if a cell existed before but is no longer in current ui,
	# remove its designated border
	
	for key in last_ui_state:
		var last_cell: BrainCell = last_ui_state[key]
		var curr_cell: BrainCell = ui_state[key]
		
		# if we use to have it
		if last_cell and not curr_cell:
			GLBreedingComponetsBus.emit_signal(
				"toggle_wanted_highlight",
				false,
				last_cell.name,
				""
			)
		
		# if cell changed, remove old cell border
		elif last_cell and curr_cell:
			if last_cell.name != curr_cell.name:
				GLBreedingComponetsBus.emit_signal(
					"toggle_wanted_highlight",
					false,
					last_cell.name,
					""
				)
	
	
	# 2. look through CURRENT ui and panel state
	# if cell exists in both, remove designated border
	# if cell only exists in ui, show designated border
	
	for key in ui_state:
		
		var ui_cell: BrainCell = ui_state[key]
		
		if not ui_cell:
			continue
		
		var box_type: String = get_box_type(key)
		var cell_on_panel: bool = false
		
		for panel_key in panel_state:
			
			# only compare against same type
			if get_box_type(panel_key) != box_type:
				continue
			
			var panel_cell: BrainCell = panel_state[panel_key]
			
			if panel_cell and panel_cell.name == ui_cell.name:
				cell_on_panel = true
				break
		
		
		if cell_on_panel:
			GLBreedingComponetsBus.emit_signal(
				"toggle_wanted_highlight",
				false,
				ui_cell.name,
				box_type
			)
		
		else:
			GLBreedingComponetsBus.emit_signal(
				"toggle_wanted_highlight",
				true,
				ui_cell.name,
				box_type
			)
	
	
	# 3. make sure box borders follow the same wanted / not wanted state
	# handled through toggle_wanted_highlight


func get_box_type(key: String) -> String:
	if key.contains("main"):
		return "main"
	
	if key.contains("boost"):
		return "boost"
	
	push_error("Could not find box type for key: ", key)
	return ""
