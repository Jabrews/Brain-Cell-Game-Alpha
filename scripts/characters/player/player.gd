extends CharacterBody3D

## export vars
@export var mouse_sensitivity_x := 0.006
@export var mouse_sensitivity_y := 0.004

var saved_mouse_sensitivty_x : float
var saved_mouse_sensitivty_y : float


## controller look
@export var controller_sensitivity_x: float = 3.0
@export var controller_sensitivity_y: float = 2.5

@export var controller_deadzone: float = 0.16
@export var controller_curve: float = 1.8
@export var controller_acceleration: float = 18.0

var controller_look_velocity: Vector2 = Vector2.ZERO


## camera bob
@export var bob_amp: float = 0.04
@export var bob_freq: float = 2.0
@export var bob_return_speed: float = 8.0

var t_bob: float = 0.0
var camera_starting_position: Vector3


## components
@onready var camera_pivot : Node3D = $CameraPivot
@onready var camera := $CameraPivot/Camera3D
@onready var interact_ray : RayCast3D = $CameraPivot/Camera3D/RayCastController/InteractRay


var speed : float = 15.0

var is_paused : bool = false

var starting_postion : Vector3


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	starting_postion = global_position
	camera_starting_position = camera.position
	
	# update char refrence state
	GLPlayerState.player_refrence = self
	
	GLPlayerState.connect(
		'lock_player_position',
		_handle_lock_player_position
	)
	
	GLGameManagerBus.connect(
		'reset_player_position',
		_handle_reset_player_position
	)
	
	GLMutationExsplosiveState.connect(
		'shake_player_cam_from_exsplode',
		_handle_shake_player_cam_from_exsplode
	)
	
	GLPlayerState.connect(
		'toggle_pickup_reduce_player_senstivty',
		_handle_toggle_pickup_reduce_player_senstivty
	)
	
	saved_mouse_sensitivty_x = mouse_sensitivity_x
	saved_mouse_sensitivty_y = mouse_sensitivity_y


func _process(delta: float) -> void:
	if is_paused:
		return

	_handle_controller_look(delta)


func _handle_controller_look(delta: float) -> void:
	var input := Vector2(
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	)

	# radial deadzone
	input = _apply_controller_deadzone(input)

	# response curve
	input.x = sign(input.x) * pow(abs(input.x), controller_curve)
	input.y = sign(input.y) * pow(abs(input.y), controller_curve)

	# small precision slowdown near center
	var precision_multiplier := 1.0

	if input.length() < 0.45:
		precision_multiplier = 0.65

	var target_velocity := Vector2(
		input.x * controller_sensitivity_x * precision_multiplier,
		input.y * controller_sensitivity_y * precision_multiplier
	)

	# fast smoothing without feeling floaty
	var smoothing_amount := 1.0 - exp(-controller_acceleration * delta)

	controller_look_velocity = controller_look_velocity.lerp(
		target_velocity,
		smoothing_amount
	)

	camera_pivot.rotate_y(
		-controller_look_velocity.x * delta
	)

	camera.rotate_x(
		-controller_look_velocity.y * delta
	)

	camera.rotation.x = clamp(
		camera.rotation.x,
		deg_to_rad(-70),
		deg_to_rad(80)
	)


func _apply_controller_deadzone(input: Vector2) -> Vector2:
	var input_length := input.length()

	if input_length < controller_deadzone:
		return Vector2.ZERO

	var adjusted_length := (
		(input_length - controller_deadzone)
		/ (1.0 - controller_deadzone)
	)

	return input.normalized() * adjusted_length


func _physics_process(delta: float) -> void:
	if is_paused:
		return
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor() and Input.is_action_just_pressed('jump'):
		velocity.y += 10
	
	
	##### dir #####
	var input_dir := Input.get_vector(
		"left",
		"right",
		"up",
		"down"
	)
	
	var direction := (
		camera_pivot.transform.basis
		* Vector3(input_dir.x, 0, input_dir.y)
	).normalized()
	
	
	## movement
	if direction.length() > 0.0:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	
		# for when holding btn for instance
		if GLHoldingDisplayBus.player_is_holding == true:
			GLHoldingDisplayBus.emit_signal(
				'player_interupted_hold'
			)
					
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			speed
		)
		
		velocity.z = move_toward(
			velocity.z,
			0,
			speed
		)
	
	camera_bobble(delta)
		
	move_and_slide()


### BOBBLE + CAMERA ###
func _unhandled_input(event: InputEvent) -> void:
	if is_paused:
		return
	
	if event is InputEventMouseMotion:
		camera_pivot.rotate_y(
			-event.relative.x * mouse_sensitivity_x
		)
		
		camera.rotate_x(
			-event.relative.y * mouse_sensitivity_y
		)
		
		camera.rotation.x = clamp(
			camera.rotation.x,
			deg_to_rad(-70),
			deg_to_rad(80)
		)


func camera_bobble(delta: float) -> void:
	var horizontal_speed := Vector2(
		velocity.x,
		velocity.z
	).length()

	if horizontal_speed > 0.1 and is_on_floor():
		t_bob += delta * horizontal_speed

		var bob_offset := _headbob(t_bob)

		camera.position = camera_starting_position + bob_offset

	else:
		camera.position = camera.position.lerp(
			camera_starting_position,
			1.0 - exp(-bob_return_speed * delta)
		)


func _headbob(time: float) -> Vector3:
	var pos := Vector3.ZERO
	
	pos.y = sin(time * bob_freq) * bob_amp
	
	return pos


func _handle_reset_player_position():
	global_position = starting_postion


func _handle_lock_player_position(toggle_value : bool):
	if toggle_value:
		is_paused = true
		visible = false
		
		interact_ray.collide_with_areas = false
		
		controller_look_velocity = Vector2.ZERO
		
		camera.position = camera_starting_position
		
	else:
		is_paused = false
		visible = true
		
		interact_ray.collide_with_areas = true


func _handle_shake_player_cam_from_exsplode() -> void:
	var original_position: Vector3 = camera_pivot.position

	var shake_tween: Tween = create_tween()

	var shake_amount: float = 0.12
	var shake_step_time: float = 0.04
	var shake_steps: int = 8

	for i: int in range(shake_steps):
		var random_offset: Vector3 = Vector3(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount),
			0.0
		)

		shake_tween.tween_property(
			camera_pivot,
			"position",
			original_position + random_offset,
			shake_step_time
		)

	shake_tween.tween_property(
		camera_pivot,
		"position",
		original_position,
		shake_step_time
	)


func _handle_toggle_pickup_reduce_player_senstivty(toggle_value : bool):
	if toggle_value:
		mouse_sensitivity_x = mouse_sensitivity_x * 0.6
		mouse_sensitivity_y = mouse_sensitivity_y * 0.6
	else:
		mouse_sensitivity_x = saved_mouse_sensitivty_x
		mouse_sensitivity_y = saved_mouse_sensitivty_y
