extends Node

var selected_material : StandardMaterial3D
var unselected_material : StandardMaterial3D

# components
@onready var two_pris_btn_mesh : MeshInstance3D =$"../PrisonerQuanityBtns/TwoPrisonerBtn/MeshInstance3D"
@onready var four_pris_btn_mesh : MeshInstance3D = $"../PrisonerQuanityBtns/FourPrisonerBtn/MeshInstance3D"


func _ready() -> void:
	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_next_turn)
	GLGameManagerBus.connect('process_next_round', _handle_next_round)
	
	
	selected_material = StandardMaterial3D.new()
	selected_material.albedo_color = Color.DARK_BLUE

	unselected_material = StandardMaterial3D.new()
	unselected_material.albedo_color = Color.GRAY
	
	two_pris_btn_mesh.material_override = unselected_material 
	four_pris_btn_mesh.material_override = unselected_material 

func _prisoner_quanity_btn_selected(quanity : int) :
	if quanity == 0 : 
		two_pris_btn_mesh.material_override = unselected_material 
		four_pris_btn_mesh.material_override = unselected_material
	if quanity == 2 :
		two_pris_btn_mesh.material_override = selected_material
		four_pris_btn_mesh.material_override = unselected_material
	elif quanity == 4 :
		two_pris_btn_mesh.material_override = unselected_material 
		four_pris_btn_mesh.material_override = selected_material 
	else : 
		return

func _handle_next_turn() :
	_prisoner_quanity_btn_selected(0)

func _handle_next_round() :
	_prisoner_quanity_btn_selected(0)
