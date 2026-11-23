extends Node

# receiving transfer box
@export var recieving_transfer_box : Node3D

# components
@onready var detect_cell_open_area : Area3D = $DetectCellOpenArea
@onready var transfer_door_mesh : MeshInstance3D = $TransferBox_Door/TransferBox_Door
@onready var transfer_door_coll : CollisionShape3D = $TransferBox_Door/CollisionShape3D
@onready var detect_cell_place_area : Area3D = $DetectCellPlaceArea
@onready var cell_placement : Node3D = $CellPlacement
@onready var smoke_particle : GPUParticles3D = $SmokeParticle
@onready var s_open : AudioStreamPlayer3D = $Audio/Open
@onready var s_close : AudioStreamPlayer3D = $Audio/Close
@onready var s_teleport : AudioStreamPlayer3D = $Audio/Teleport

var open_close_tween : Tween
var receiving_cell : bool = false
var has_cell : bool = false


func _ready() -> void:

	# open area
	detect_cell_open_area.body_entered.connect(_open_area_handle_body_entered)
	detect_cell_open_area.body_exited.connect(_open_area_handle_body_exited)

	# place area
	detect_cell_place_area.body_entered.connect(_place_area_handle_body_entered)
	detect_cell_place_area.body_exited.connect(_place_area_handle_body_exited)


func _open_area_handle_body_entered(body : Node3D) -> void:

	if receiving_cell:
		return

	if has_cell:
		return

	if body.is_in_group("brain_cell_container"):
		toggle_door_open(true)


func _open_area_handle_body_exited(body : Node3D) -> void:

	if receiving_cell:
		return

	if has_cell:
		return

	if body.is_in_group("brain_cell_container"):
		toggle_door_open(false)


func toggle_door_open(toggle_value : bool) -> void:

	# stop previous tween
	if open_close_tween:
		open_close_tween.kill()

	open_close_tween = create_tween()

	if toggle_value:
		
		s_open.play()

		# enable collision while opening
		transfer_door_coll.set_deferred("disabled", false)

		# open door
		open_close_tween.tween_property(
			transfer_door_mesh,
			"blend_shapes/Key 1",
			1.0,
			0.3
		)

		# allow placement detection
		detect_cell_place_area.set_deferred("monitoring", true)

		# disable collision when fully open
		open_close_tween.tween_callback(
			func():
				transfer_door_coll.set_deferred("disabled", true)
		)

	else:

		s_close.play()

		# stop placement detection
		detect_cell_place_area.set_deferred("monitoring", false)

		# re-enable collision
		transfer_door_coll.set_deferred("disabled", false)

		# close door
		open_close_tween.tween_property(
			transfer_door_mesh,
			"blend_shapes/Key 1",
			0.0,
			0.3
		)


func _place_area_handle_body_entered(body : Node3D) -> void:

	if receiving_cell:
		return

	if has_cell:
		return

	if not body.is_in_group("brain_cell_container"):
		return

	# mark this box as occupied
	has_cell = true

	# stop detecting the cell
	detect_cell_place_area.set_deferred("monitoring", false)
	detect_cell_open_area.set_deferred("monitoring", false)

	# close sender door
	toggle_door_open(false)

	# set cell state
	body.switch_cell_state("idle")

	# put cell at sender placement
	body.global_position = cell_placement.global_position

	# wait
	await get_tree().create_timer(0.5).timeout

	# play smoke
	smoke_particle.emitting = true
	
	s_teleport.play()

	# wait for smoke
	await smoke_particle.finished

	# check receiver before transferring
	if recieving_transfer_box:

		if recieving_transfer_box.has_cell:
			# receiver is occupied
			has_cell = false
			detect_cell_open_area.set_deferred("monitoring", true)
			return

		recieving_transfer_box._handle_recieve_cell(body)
		

	# allow sender to detect another cell
	has_cell = false
	detect_cell_open_area.set_deferred("monitoring", true)


func _place_area_handle_body_exited(body : Node3D) -> void:

	if not body.is_in_group("brain_cell_container"):
		return

	# only close if this box received the cell
	if receiving_cell:

		receiving_cell = false
		has_cell = false

		toggle_door_open(false)

		# allow this box to detect another cell
		detect_cell_open_area.set_deferred("monitoring", true)


func _handle_recieve_cell(body : Node3D) -> void:

	if not body.is_in_group("brain_cell_container"):
		return

	# prevent another cell from being transferred here
	receiving_cell = true
	has_cell = true

	# disable detection while receiving
	detect_cell_open_area.set_deferred("monitoring", false)
	detect_cell_place_area.set_deferred("monitoring", false)

	# move cell to receiver placement
	body.global_position = cell_placement.global_position

	# open receiving door
	toggle_door_open(true)

	# wait for door to open
	await get_tree().create_timer(0.5).timeout

	# enable place area so we can detect when cell leaves
	detect_cell_place_area.set_deferred("monitoring", true)
