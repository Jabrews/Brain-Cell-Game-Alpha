extends Node


# Components
@onready var camera: Camera3D = $Camera3D

# elevator
@onready var elevator_lid_left: MeshInstance3D = $Table/ElevatorLidLeft
@onready var elevator_lid_right: MeshInstance3D = $Table/ElevatorLidRight
@onready var elevator_left: StaticBody3D = $Table/ElevatorLeft
@onready var elevator_right: StaticBody3D = $Table/ElevatorRight

# spawn pos
@onready var left_spawn_pos: Node3D = $Table/LeftSpawnPos
@onready var right_spawn_pos: Node3D = $Table/RightSpawnPos

# container packed scene
@onready var cell_container_p_s: PackedScene = preload(
	"res://scenes/characters/cell_container/cell_container.tscn"
)

# light helper
@onready var extractor_lights: Node3D =$Extractor/ExtractorLight

# areas
@onready var detect_cell_left: Area3D = $Table/DetectCellLeft
@onready var detect_cell_right: Area3D = $Table/DetectCellRight

# sounds
@onready var s_blender : AudioStreamPlayer3D = $Audio/Blender
@onready var s_blender_end : AudioStreamPlayer3D = $Audio/BlenderEnd
@onready var s_door_shut : AudioStreamPlayer3D = $Audio/DoorShut

# helper prisoner viewer
@onready var prisoner_viewer_manager : Node3D = $Extractor/PrisonerViewerManager


# cell containr parent node
@export var cell_container_parent_node: Node


const STARTING_FOV: float = 85.0
const ENDING_FOV: float = 70.0

const OPEN_LID_DURATION: float = 1.0
const ELEVATOR_DURATION: float = 1.5


var cells_to_create: Array[BrainCell] = []

var innactive: bool = false
var cells_in_elevator_spawn: bool = false

# Cells currently assigned to each elevator.
var left_elevator_cell: Node3D = null
var right_elevator_cell: Node3D = null

# Foreign cells currently inside the detector areas.
var foreign_cell_left: bool = false
var foreign_cell_right: bool = false


func _ready() -> void:

	toggle_elevator_up(false, [elevator_left, elevator_right])
	toggle_lids_open(false, [elevator_lid_left, elevator_lid_right])

	extractor_lights._switch_light_state('cells_unloaded')

	GLCellManagerBus.connect(
		"cell_added_to_collection",
		_handle_cell_added_to_collection
	)

	GLGameManagerBus.connect(
		"proceed_next_energy_turn",
		_handle_proceed_next_energy_turn
	)

	detect_cell_left.connect(
		"body_entered",
		_handle_body_enter_left
	)

	detect_cell_left.connect(
		"body_exited",
		_handle_body_exit_left
	)

	detect_cell_right.connect(
		"body_entered",
		_handle_body_enter_right
	)

	detect_cell_right.connect(
		"body_exited",
		_handle_body_exit_right
	)


### CELLS TO CREATE ARRAY ############################################


func _handle_cell_added_to_collection(new_cell: BrainCell) -> void:

	if cells_to_create.size() >= 2:
		push_error("More prisoners in extractor than allowed.")
		return

	cells_to_create.append(new_cell)
	
	if len(cells_to_create) == 1 : 
		prisoner_viewer_manager._switch_screen('1_prisoner')
	elif len(cells_to_create) == 2 : 
		prisoner_viewer_manager._switch_screen('2_prisoner')
	

	if not innactive:
		extractor_lights._switch_light_state('cells_loaded')


func _handle_proceed_next_energy_turn() -> void:

	cells_to_create.clear()
	
	prisoner_viewer_manager._switch_screen('empty')
	prisoner_viewer_manager._toggle_blood(false)

	if not innactive:
		extractor_lights._switch_light_state('cells_unloaded')


### EXTRACT BUTTON ###################################################


func _handle_extract_btn_pressed() -> void:

	# Cannot extract while the elevator is occupied.
	if innactive:
		return

	if cells_to_create.is_empty():
		return

	# Left elevator takes priority.
	if cells_to_create.size() == 1:

		initate_extractor(
			[elevator_lid_left],
			[elevator_left]
		)

	elif cells_to_create.size() == 2:

		initate_extractor(
			[elevator_lid_left, elevator_lid_right],
			[elevator_left, elevator_right]
		)

	prisoner_viewer_manager._switch_screen('empty')
	prisoner_viewer_manager._toggle_blood(true)


### EXTRACTOR CINEMATIC ##############################################


func initate_extractor(
	lids: Array[MeshInstance3D],
	elevators: Array[StaticBody3D]
) -> void:

	camera.current = true
	camera.fov = STARTING_FOV

	GLPlayerState.emit_signal(
		"lock_player_position",
		true
	)

	GLCinnamaticBus.emit_signal(
		"toggle_extractor_cinnamatic",
		true
	)


	# Camera zoom
	var cam_fov_tween: Tween = create_tween()
	
	s_blender.play()	
	
	cam_fov_tween.tween_property(
		camera,
		"fov",
		ENDING_FOV,
		ELEVATOR_DURATION + OPEN_LID_DURATION
	)

	# Open lids
	toggle_lids_open(true, lids)

	await get_tree().create_timer(
		OPEN_LID_DURATION
	).timeout

	# Spawn cells before elevator reaches top.
	_spawn_cells()

	cells_in_elevator_spawn = true

	# Raise elevators.
	toggle_elevator_up(true, elevators)

	await get_tree().create_timer(
		ELEVATOR_DURATION
	).timeout
	
	

	if cam_fov_tween.is_running():
		await cam_fov_tween.finished

	# Small finishing pause.
	await get_tree().create_timer(0.5).timeout
	
	s_blender_end.play()

	# End cinematic.
	GLCinnamaticBus.emit_signal(
		"toggle_extractor_cinnamatic",
		false
	)

	GLPlayerState.emit_signal(
		"lock_player_position",
		false
	)

	camera.current = false


### LIDS #############################################################


func toggle_lids_open(
	toggle_value: bool,
	lids: Array[MeshInstance3D]
) -> void:

	var final_rotation_x: float

	if toggle_value:
		final_rotation_x = deg_to_rad(30.0)
	else:
		final_rotation_x = deg_to_rad(-90.0)

	for lid: MeshInstance3D in lids:

		var lid_tween := create_tween()

		lid_tween.tween_property(
			lid,
			"rotation:x",
			final_rotation_x,
			OPEN_LID_DURATION
		)
		
		if final_rotation_x == deg_to_rad(-90.0) : 
			await lid_tween.finished 
			s_door_shut.play()
		


### ELEVATORS ########################################################


func toggle_elevator_up(
	toggle_value: bool,
	elevators: Array[StaticBody3D]
) -> void:

	var final_position_y: float

	if toggle_value:
		final_position_y = 3.1
	else:
		final_position_y = 2.0

	for elevator: StaticBody3D in elevators:

		var elevator_tween := create_tween()

		elevator_tween.tween_property(
			elevator,
			"position:y",
			final_position_y,
			ELEVATOR_DURATION
		)


### SPAWN CELLS ######################################################


func _spawn_cells() -> void:

	if cells_to_create.size() > 2:
		push_error("More prisoners in extractor than allowed.")
		return

	if cells_to_create.is_empty():
		return

	# First cell always goes left.
	if cells_to_create.size() >= 1:

		left_elevator_cell = _spawn_cell(
			cells_to_create[0],
			left_spawn_pos
		)

	# Second cell goes right.
	if cells_to_create.size() >= 2:

		right_elevator_cell = _spawn_cell(
			cells_to_create[1],
			right_spawn_pos
		)
		
	GLDefectEventMangerBus.emit_signal('prisoners_extracted', len(cells_to_create))		
		
	cells_to_create.clear()

	# Extractor is now occupied.
	innactive = true
	extractor_lights._switch_light_state('inactive')


func _spawn_cell(
	cell: BrainCell,
	spawn_position: Node3D
) -> Node3D:

	var cell_container = cell_container_p_s.instantiate()

	cell_container.name = cell.name
	cell_container.designated_brain_cell = cell

	cell_container_parent_node.add_child(
		cell_container
	)

	cell_container.global_position = spawn_position.global_position

	return cell_container


### CELL AREA ########################################################

func _handle_body_enter_left(body: Node3D) -> void:

	if not body.is_in_group('brain_cell_container'):
		return

	# This is the cell belonging to the left elevator.
	if body == left_elevator_cell:
		return

	# Any other cell entering the area makes the extractor inactive.
	foreign_cell_left = true

	extractor_lights._switch_light_state('inactive')


func _handle_body_exit_left(body: Node3D) -> void:

	if not body.is_in_group('brain_cell_container'):
		return

	# Expected elevator cell leaving.
	if body == left_elevator_cell:

		left_elevator_cell = null

		toggle_elevator_up(
			false,
			[elevator_left]
		)

		toggle_lids_open(
			false,
			[elevator_lid_left]
		)

		cells_in_elevator_spawn = false

		_check_extractor_available()

		return

	# Foreign cell leaving.
	foreign_cell_left = false

	_update_extractor_light_state()


func _handle_body_enter_right(body: Node3D) -> void:

	if not body.is_in_group('brain_cell_container'):
		return

	# This is the cell belonging to the right elevator.
	if body == right_elevator_cell:
		return

	# Any other cell entering the area makes the extractor inactive.
	foreign_cell_right = true

	extractor_lights._switch_light_state('inactive')


func _handle_body_exit_right(body: Node3D) -> void:

	if not body.is_in_group('brain_cell_container'):
		return

	# Expected elevator cell leaving.
	if body == right_elevator_cell:

		right_elevator_cell = null

		toggle_elevator_up(
			false,
			[elevator_right]
		)

		toggle_lids_open(
			false,
			[elevator_lid_right]
		)

		cells_in_elevator_spawn = false

		_check_extractor_available()

		return

	# Foreign cell leaving.
	foreign_cell_right = false

	_update_extractor_light_state()


### EXTRACTOR AVAILABILITY ###########################################


func _check_extractor_available() -> void:

	# Left elevator still has its cell.
	if left_elevator_cell != null:
		innactive = true
		extractor_lights._switch_light_state('inactive')
		return

	# Right elevator still has its cell.
	if right_elevator_cell != null:
		innactive = true
		extractor_lights._switch_light_state('inactive')
		return

	# Both elevator cells have left.
	innactive = false

	_update_extractor_light_state()


### LIGHT STATE #####################################################


func _update_extractor_light_state() -> void:

	if innactive:
		extractor_lights._switch_light_state('inactive')
		return

	# If either detector still has a foreign cell,
	# remain inactive.
	if foreign_cell_left or foreign_cell_right:
		extractor_lights._switch_light_state('inactive')
		return

	# If there are cells waiting to be extracted,
	# show loaded.
	if not cells_to_create.is_empty():
		extractor_lights._switch_light_state('cells_loaded')
		return

	# Otherwise show unloaded.
	extractor_lights._switch_light_state('cells_unloaded')
