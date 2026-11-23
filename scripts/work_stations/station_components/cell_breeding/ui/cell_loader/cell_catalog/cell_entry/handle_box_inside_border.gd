extends Node

@onready var parent_box : Control = $".."
@onready var on_border : TextureRect = $"../InsideBorderEffects/On"
@onready var wanted_border : TextureRect = $"../InsideBorderEffects/Wanted"

func _ready() -> void:
	GLBreedingComponetsBus.connect('toggle_cell_box_border', _handle_toggle_cell_box_border)
	GLBreedingComponetsBus.connect('reset_borders', _handle_reset_borders)

func _handle_reset_borders() :
	on_border.visible = false
	wanted_border.visible = false

func _handle_toggle_cell_box_border(box_type : String, box_side : String, is_wanted : bool) :
	
	var parent_box_type : String = parent_box.box_type
	var parent_box_side: String = parent_box.side
	
	if box_type != parent_box_type : 
		return
	
	if parent_box_side != box_side : 
		return
	
	# reset borders
	on_border.visible = false
	wanted_border.visible = false
	
	if is_wanted :
		wanted_border.visible = true
	else : 
		on_border.visible = true
	



	#
	#
	#
	#var loaded_cell_name = parent_cell_entry.loaded_cell.name
	#
	#if loaded_cell_name != cell_name : 
		#return
	#
	#reset()
	#
	#var border : TextureRect 	
	#
	#match border_type  :
		#'boost' : 
			#if is_wanted : 
				#border = wanted_boost_border
			#else : 
				#border = on_boost_border
		#'main' :
			#if is_wanted : 
				#border = wanted_main_border
			#else : 
				#border = on_main_border
		#'selected':  
			#border = on_selected_border
		#_ : 
			#push_error('couldnt find border type  : ', border_type)
			#border = on_selected_border
	#
	#border.visible = true
	#
#func reset() :	
	#on_boost_border.visible = false
	#on_main_border.visible = false
	#wanted_boost_border.visible = false
	#wanted_main_border.visible = false
	#on_selected_border.visible = false
	#
	#
	#
	#
	#
	#
	#
	#
