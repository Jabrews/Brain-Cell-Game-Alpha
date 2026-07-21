extends Node3D

@onready var screen_stat_reciever_display : Node2D = $StatMesh/SubViewport/BasicRecieverScreen

# mutation mesh ndoe stuff
@onready var mutation_mesh_tv_scene : PackedScene = preload("res://scenes/characters/reusable/stat_display/mutation_mesh_tv.tscn")
@onready var mutation_mesh_parent : Node3D = $MutationMeshParent
@onready var shake_sentient_mutation : Node = $ShakeSentientMutation




@export var yaw_offset: float = 0.0

var player : CharacterBody3D


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
		
		# shaking first round sientient
		if mutation.type == 'sentient'	 :
			if GLGameManagerBus.current_round == 1  :
				if IVMutations.picked_sentient_mutation_first_round : 
					shake_sentient_mutation._toggle_sentient_shake(false, mutation_mesh_tv_instance)
				else : 
					shake_sentient_mutation._toggle_sentient_shake(true, mutation_mesh_tv_instance)

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
		
	if visible and player : 
		_face_player_y_only()


func _face_player_y_only() -> void:
	var dir: Vector3 = player.global_position - global_position
	dir.y = 0.0

	if dir.length_squared() <= 0.001:
		return

	var target_yaw: float = atan2(dir.x, dir.z) + yaw_offset

	global_rotation.y = target_yaw

func set_player_reference(player_reference: CharacterBody3D) -> void:
	player = player_reference
