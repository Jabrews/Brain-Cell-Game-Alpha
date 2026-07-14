extends Node

var selected_material : StandardMaterial3D
var unselected_material : StandardMaterial3D
var safe_mode_selected_material : StandardMaterial3D

# components
@onready var one_picks_btn_mesh : MeshInstance3D =$"../PrisonerPicksBtns/OnePicksBtn/MeshInstance3D"
@onready var two_picks_btn_mesh : MeshInstance3D = $"../PrisonerPicksBtns/TwoPicksBtn/MeshInstance3D"
@onready var parent_prisoner_profiler : Node3D = $"../.."



func _ready() -> void:
	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_next_turn)
	GLGameManagerBus.connect('process_next_round', _handle_next_round)
	
	
	selected_material = StandardMaterial3D.new()
	selected_material.albedo_color = Color.DARK_BLUE

	unselected_material = StandardMaterial3D.new()
	unselected_material.albedo_color = Color.GRAY
	
	safe_mode_selected_material = StandardMaterial3D.new()
	safe_mode_selected_material.albedo_color = Color.GREEN
	
	one_picks_btn_mesh.material_override = unselected_material
	two_picks_btn_mesh.material_override = unselected_material

func _prisoner_picks_btn_selected(picks: int) :
	
	# prevent switching picks if safe mode active	
	if parent_prisoner_profiler.safe_mode_active :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	if picks == 0 :
		one_picks_btn_mesh.material_override = unselected_material
		two_picks_btn_mesh.material_override = unselected_material
	if picks == 1 :
		one_picks_btn_mesh.material_override = selected_material
		two_picks_btn_mesh.material_override = unselected_material
	elif picks == 2 :
		one_picks_btn_mesh.material_override = unselected_material
		two_picks_btn_mesh.material_override = selected_material
	else :
		return

func _safe_mode_disable_btns(toggle_value : bool) :
	
	if toggle_value : 
		one_picks_btn_mesh.material_override = safe_mode_selected_material 
		two_picks_btn_mesh.material_override = unselected_material
	else : 
		one_picks_btn_mesh.material_override = unselected_material 
		two_picks_btn_mesh.material_override = unselected_material
		


func _handle_next_turn() :
	_prisoner_picks_btn_selected(0)

func _handle_next_round() :
	_prisoner_picks_btn_selected(0)
