extends Node

# components
@onready var cell_entry_container : GridContainer = $"../BreedingUI/CellLoader/CellCatalog/CenterContainer/ScrollContainer/GridContainerLeft"



func _handle() :
	
	
	# TODO diffrentiate bewtween wanted vs om border here too	
	
	# 1. loop through keys and value of dictonary
	# 2. if cell found : load correct border on entry
	
	var breeding_ui_state : Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_ui_state.duplicate()
	
	for box_type : String in breeding_ui_state : 
		
		var box_cell : BrainCell = breeding_ui_state[box_type]
		
		# dont care about state if no cell in spot
		if not box_cell : 
			return
			
		# find corrisponding cell entry
		for cell_entry : Control in cell_entry_container.get_children() : 
			var entry_loaded_cell : BrainCell = cell_entry.loaded_cell			
			
			var entry_cell_name : String = entry_loaded_cell.name
			
			# if found load correct border			
			if entry_cell_name ==  box_cell.name : 
				
				# get border type 
				var border_type : String = box_type_to_border_type(box_type)
				
				GLBreedingComponetsBus.emit_signal('toggle_cell_entry_border', entry_cell_name, border_type, true)
			
				
func box_type_to_border_type(box_type : String) -> String : 
	match box_type : 
		'left_main' : 		
			return 'wanted_main'
		'right_main' :
			return 'wanted_main'
		'left_boost' :
			return 'wanted_boost'
		'right_boost' :
			return 'wanted_boost'
		_ : 
			push_error('trouble getting border type from box type of : ', box_type)
			return 'wanted_main'
			
		
		
			
			
			
			
		
		
	
