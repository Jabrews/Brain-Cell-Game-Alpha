extends Node

# components
@onready var elevator_light_mesh: MeshInstance3D = $"../../../Elevator/Light/LightMesh"
@onready var elevator_light: SpotLight3D = $"../../../Elevator/Light/Light"
@onready var flash_timer : Timer = $FlashTimer

const RED_COLOR: Color = Color("#a12020")
const GREEN_COLOR: Color = Color("#43a123")

const LIGHT_ENERGY: float = 2.0
const FLASH_INTERVAL: float = 0.25

var light_material: StandardMaterial3D

var current_state: String = "off"
var flash_on: bool = false



func _ready() -> void:
	
	
	# duplicate light mesh material
	light_material = elevator_light_mesh.get_active_material(0).duplicate()
	
	elevator_light_mesh.set_surface_override_material(
		0,
		light_material
	)
	
	
	flash_timer.wait_time = FLASH_INTERVAL
	flash_timer.connect('timeout', _handle_flash_timer)
	
	_switch_state("off")


func _switch_state(new_state: String) -> void:
	
	current_state = new_state
	
	flash_timer.stop()
	flash_on = false
	
	
	match new_state:
		
		# off red light
		"off":
			_set_light(RED_COLOR, true)
		
		
		# returning cell - red flashing
		"returning_cell":
			_set_light(RED_COLOR, true)
			flash_on = true
			flash_timer.start()
		
		
		# on green light
		"on":
			_set_light(GREEN_COLOR, true)
		
		
		# dissolving cell - green flashing
		"dissolving_cell":
			_set_light(GREEN_COLOR, true)
			flash_on = true
			flash_timer.start()
		
		
		_:
			push_warning(
				"Unknown elevator light state: " + new_state
			)


func _handle_flash_timer() -> void:
	
	flash_on = !flash_on
	
	match current_state:
		
		"returning_cell":
			_set_light(
				RED_COLOR,
				flash_on
			)
		
		"dissolving_cell":
			_set_light(
				GREEN_COLOR,
				flash_on
			)


func _set_light(
	color: Color,
	toggle_value: bool
) -> void:
	
	# actual light
	elevator_light.light_color = color
	
	if toggle_value:
		elevator_light.light_energy = LIGHT_ENERGY
	else:
		elevator_light.light_energy = 0.0
	
	
	# glowing mesh
	light_material.albedo_color = color
	light_material.emission_enabled = true
	light_material.emission = color
	
	if toggle_value:
		light_material.emission_energy_multiplier = 2.0
	else:
		light_material.emission_energy_multiplier = 0.0
