extends Node3D

@onready var screen_stat_reciever_display : Node2D = $StatMesh/SubViewport/BasicRecieverScreen
@onready var parent_body : CharacterBody3D = $".."

# mutation mesh ndoe stuff
@onready var mutation_mesh_tv_scene : PackedScene = preload("res://scenes/characters/reusable/stat_display/mutation_mesh_tv.tscn")
@onready var mutation_mesh_parent : Node3D = $MutationMeshParent
@onready var shake_sentient_mutation : Node = $ShakeSentientMutation
@onready var stat_mesh : MeshInstance3D = $StatMesh

@export var yaw_offset: float = 0.0
var show_distance : float = 4.0

var player : CharacterBody3D


func _ready() -> void:
	GLMutationSentientState.connect('toggle_cell_near_death_event', _handle_toggle_cell_near_death_event)


func _handle_brain_cell_recieved(cell : BrainCell) -> void:
	
	screen_stat_reciever_display._handle_brain_cell_recieved(cell)
	
	# dealing with mutation screens
	reset_mutation_tvs()
	if len(cell.mutations) > 0 : 
		load_mutation_screen(cell.mutations)
	
func load_mutation_screen(mutations : Array[BrainCellMutation]) :	

	if len(mutations) > 3 : 
		push_error('too many mutations on cell to display')
	
	var mutation_index = 0
	
	for mutation in mutations : 	
		var mutation_mesh_tv_instance : MeshInstance3D = mutation_mesh_tv_scene.instantiate()
		
		mutation_mesh_parent.add_child(mutation_mesh_tv_instance)
		

			
		# set in proper position
		match mutation_index : 	
			0 : 
				mutation_mesh_tv_instance.position = Vector3(0.008, 1.529, -1.05)
			1 : 
				mutation_mesh_tv_instance.position = Vector3(0.008, 0.933, -1.05)
			2 : 
				mutation_mesh_tv_instance.position = Vector3(0.008, 1.529, -1.73)
				
		var screen_mutation_display: Node2D = mutation_mesh_tv_instance.get_node(
			"SubViewport/MutationRecieverScreen"
		)

		screen_mutation_display._handle_mutation_recieved(mutation)
		
		mutation_index += 1

func reset_mutation_tvs() :
	for mution_mesh_tv : MeshInstance3D in mutation_mesh_parent.get_children() :
		mution_mesh_tv.queue_free()
		
func handle_first_round_sientient_cell_bounce() :		
	pass

	
	

func _process(_delta: float) -> void:
	if not visible:
		return
	
	if not player:
		return
	
	
	if not parent_body.velocity == Vector3.ZERO : 
		return
		
	if visible and player : 
		_face_player_y_only()
		_auto_turn_off()


func _face_player_y_only() -> void:
	
	rotation = Vector3.ZERO
	
	var dir: Vector3 = player.global_position - global_position
	dir.y = 0.0

	if dir.length_squared() <= 0.001:
		return

	var target_yaw: float = atan2(dir.x, dir.z) + yaw_offset

	global_rotation.y = target_yaw

func set_player_reference(player_reference: CharacterBody3D) -> void:
	player = player_reference



func _auto_turn_off() -> void:

	if player == null:
		return

	var distance_to_player: float = global_position.distance_to(
		player.global_position
	)

	visible = distance_to_player <= show_distance


func _handle_toggle_cell_near_death_event(toggle_value : bool, cell_name : String) :
	
	var brain_cell : BrainCell = parent_body.designated_brain_cell 
	
	if brain_cell.name == cell_name : 
		if toggle_value : 
			stat_mesh.visible = false
			mutation_mesh_parent.visible = false
		else : 
			stat_mesh.visible = true 
			mutation_mesh_parent.visible = true
	
	
