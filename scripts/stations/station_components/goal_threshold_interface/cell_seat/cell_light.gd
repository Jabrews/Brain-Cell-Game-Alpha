extends Node

@export var inital_light_stat : String = "inactive"

# Components
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var light: SpotLight3D = $SpotLight3D
@onready var blink_interval_timer : Timer = $BlinkInterval


var c_seat_unfilled : Color = Color.RED
var c_seat_filled : Color = Color.GREEN
var c_seat_inactive : Color = Color.WHITE
var c_seat_finished : Color = Color.YELLOW

var curr_light_state : String
var blink_on : bool = true


func _ready() -> void:
	blink_interval_timer.connect("timeout", _handle_blink_interval)
	
	_switch_light_state(inital_light_stat)


func _switch_light_state(state: String) -> void:
	
	curr_light_state = state
	
	# stop any prior blinking whenever state changes
	blink_interval_timer.stop()
	blink_on = true
	
	match state:

		"seat_filled":
			light.light_color = c_seat_filled
			light.light_energy = 1.0
			_set_mesh_color(c_seat_filled)

		"seat_unfilled":
			light.light_color = c_seat_unfilled
			light.light_energy = 1.0
			_set_mesh_color(c_seat_unfilled)

		"seat_finished":
			light.light_color = c_seat_finished
			light.light_energy = 1.0
			_set_mesh_color(c_seat_finished)
			
			blink_interval_timer.start()

		"seat_dissolving":
			light.light_color = c_seat_filled
			light.light_energy = 1.0
			_set_mesh_color(c_seat_filled)
			
			blink_interval_timer.start()

		"inactive":
			light.light_color = c_seat_inactive
			light.light_energy = 0.0
			_set_mesh_color(c_seat_inactive)

		_:
			push_error("Unknown seat light state: " + state)


func _handle_blink_interval() -> void:
	
	# only these states are allowed to blink
	if curr_light_state != "seat_finished" and curr_light_state != "seat_dissolving":
		blink_interval_timer.stop()
		return
	
	blink_on = not blink_on
	
	if blink_on:
		light.light_energy = 1.0
	else:
		light.light_energy = 0.0


func _set_mesh_color(color: Color) -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	
	mesh.material_override = material
