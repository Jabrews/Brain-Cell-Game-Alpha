extends Node

# components
@onready var parent_cell_container : CharacterBody3D = $".."
@onready var boost_wanted_mesh : MeshInstance3D = $BoostWanted
@onready var main_wanted_mesh : MeshInstance3D = $MainWanted



func _reset_highlight() :
	boost_wanted_mesh.visible = false
	main_wanted_mesh.visible = false


func _ready() -> void:
	
	GLBreedingComponetsBus.connect('reset_borders', _handle_toggle_wanted_highlight)
	
	
func _handle_toggle_wanted_highlight(toggle_value : bool, cell_name : String, highlight_type : String):
	
	var parent_cell_name : String = parent_cell_container.designated_brain_cell.name
	
	if cell_name != parent_cell_name :
		return
	
	boost_wanted_mesh.visible = false
	main_wanted_mesh.visible = false
	# TODO also reset tween
	
	# if false just set all off and return
	if not toggle_value : 	
		return
	
	match highlight_type : 
		'main' : 
			main_wanted_mesh.visible = true
		'boost' : 
			boost_wanted_mesh.visible = true
	
	#var boost_tween : Tween = create_tween()
	#
	#boost_tween.set_loops()
	#
	#boost_tween.tween_property(main_wanted_mesh, 'scale', Vector3(1.1, 1.1, 1.1), 0.5)
	#boost_tween.tween_property(main_wanted_mesh, 'scale', Vector3(1.0, 1.0, 1.0), 0.5)
	#
