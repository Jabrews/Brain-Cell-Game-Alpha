extends Control

# component timer
@onready var flash_delay_timer: Timer = $FlashDelayTimer

@export var disrupt_manager: Control

@onready var parent_screen: Node2D =$".."


func _ready() -> void:
	GLMutationDisruptState.connect(
		"disrupt_incoming",
		_handle_disrupt_incoming
	)

	GLMutationDisruptState.connect(
		"disrupt_ended",
		_handle_disrupt_ended
	)

	flash_delay_timer.connect(
		"timeout",
		_handle_flash_delay_timer_timeout
	)


func _handle_disrupt_incoming(room_name: String) -> void:
	var active_room_name: String = get_active_room_name()

	if active_room_name.is_empty():
		flash_delay_timer.stop()
		visible = false
		return

	# Screen is not in the room being disrupted.
	if active_room_name != room_name:
		flash_delay_timer.stop()
		visible = false
		return

	# Don't show warning once the actual interruption is displaying.
	if disrupt_manager.displaying_interuption:
		return

	if flash_delay_timer.is_stopped():
		flash_delay_timer.start()
		visible = true


func _handle_disrupt_ended() -> void:
	flash_delay_timer.stop()
	visible = false


func _handle_flash_delay_timer_timeout() -> void:
	visible = !visible


func get_active_room_name() -> String:
	if parent_screen.is_cell_container:
		return get_cell_container_room()

	elif parent_screen.is_basic_station:
		return parent_screen.basic_station_room_name

	else:
		return ""


func get_cell_container_room() -> String:
	var cell_container : CharacterBody3D = (
		parent_screen
		.get_parent()
		.get_parent()
		.get_parent()
		.parent_body
	)

	if not cell_container:
		push_error("Unable to find cell container.")
		return ""

	var cell_name: String = cell_container.designated_brain_cell.name

	for room_profile: EntityRoomProfile in GLEntityRoomManagementBus.entity_room_profiles:
		if (
			room_profile.entity_type == "cell_container"
			and room_profile.entity_name == cell_name
		):
			return room_profile.room_name

	return ""
