extends Area3D

# components
@onready var parent_station: Node = $"../.."
@onready var boost_light_manager : StaticBody3D = $BoostLightManager

@export_enum("left", "right")
var side: String = "left"

var type : String = 'boost'


func _ready() -> void:
	body_entered.connect(_handle_body_entered)
	body_exited.connect(_handle_body_exited)
	
	GLCellManagerBus.connect("cell_changed", _handle_cell_changed)
	GLCellManagerBus.connect("cell_deleted", _handle_cell_deleted)


func _handle_body_entered(body: Node3D) -> void:
	
	var incoming_cell: BrainCell = body.designated_brain_cell

	if incoming_cell == null:
		return

	var seat_type: String = get_seat_type()

	# don't replace an existing cell
	if parent_station.get_panel_cell(seat_type) != null:
		return

	parent_station.set_panel_cell(seat_type, incoming_cell)
	boost_light_manager._toggle_light(true)


func _handle_body_exited(body: Node3D) -> void:
	
	var exiting_cell: BrainCell = body.designated_brain_cell

	if exiting_cell == null:
		return

	var seat_type: String = get_seat_type()
	var station_cell: BrainCell = parent_station.get_panel_cell(seat_type)

	if station_cell == null:
		return

	# only clear if this body owns the currently stored cell
	if station_cell.name != exiting_cell.name:
		return

	parent_station.set_panel_cell(seat_type, null)
	boost_light_manager._toggle_light(false)


func _handle_cell_changed(cell: BrainCell) -> void:
	
	var seat_type: String = get_seat_type()
	var station_cell: BrainCell = parent_station.get_panel_cell(seat_type)
	
	if station_cell == null:
		return
	
	if station_cell.name != cell.name:
		return
	
	# update stored reference/data
	parent_station.set_panel_cell(seat_type, cell)


func _handle_cell_deleted(cell_name: String) -> void:
	
	var seat_type: String = get_seat_type()
	var station_cell: BrainCell = parent_station.get_panel_cell(seat_type)
	
	if station_cell == null:
		return
	
	if station_cell.name != cell_name:
		return
	
	parent_station.set_panel_cell(seat_type, null)
	boost_light_manager._toggle_light(false)


func get_seat_type() -> String:
	match side:
		"left":
			return "left_boost"

		"right":
			return "right_boost"

		_:
			push_error("Invalid side: ", side)
			return ""
