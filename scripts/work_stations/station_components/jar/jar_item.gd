extends MeshInstance3D

# components
@onready var border_flash_delay_timer: Timer =$BorderFlashDelayTimer
@onready var border_flash_duration_timer: Timer =$BorderFlashDurationTimer
@onready var highlight_border: MeshInstance3D = $HiglightBorder


# floating
@export var float_height: float = 0.10
@export_range(0.0, 5.0, 0.05) var float_frequency: float = 0.5

# removal
@export var shrink_duration: float = 0.2
@export var grow_duration: float = 0.1
@export var shrink_scale: float = 0.05
@export var grow_scale: float = 1.25

var _starting_position: Vector3
var _starting_scale: Vector3
var _float_time: float = 0.0

var removal_tween: Tween


func _ready() -> void:
	_starting_position = position
	_starting_scale = scale

	border_flash_delay_timer.timeout.connect(
		_handle_border_flash_delay_timeout
	)
	border_flash_duration_timer.timeout.connect(
		_handle_border_flash_duration_timeout
	)



func _activate() -> void:
	border_flash_duration_timer.start()
	border_flash_delay_timer.start()

	highlight_border.visible = true


func _stop() -> void:
	border_flash_duration_timer.stop()
	border_flash_delay_timer.stop()

	highlight_border.visible = false


func _animate_removal() -> void:
	_stop()

	if removal_tween and removal_tween.is_running():
		removal_tween.kill()

	# Start from normal proportions.
	scale = _starting_scale

	removal_tween = create_tween()
	removal_tween.set_trans(Tween.TRANS_SINE)
	removal_tween.set_ease(Tween.EASE_IN_OUT)

	# Shrink quickly.
	removal_tween.tween_property(
		self,
		"scale",
		_starting_scale * shrink_scale,
		shrink_duration
	)

	# Play sound and particles at smallest size.
	removal_tween.tween_callback(_play_removal_effects)

	# Quickly expand past the original size.
	removal_tween.tween_property(
		self,
		"scale",
		_starting_scale * grow_scale,
		grow_duration * 0.5
	)

	# Return to original proportions.
	removal_tween.tween_property(
		self,
		"scale",
		_starting_scale,
		grow_duration * 0.5
	)

	await removal_tween.finished

	scale = _starting_scale


func _play_removal_effects() -> void:
	GLJarComponentBus.emit_signal('play_sound', 'item_removed')


func _process(delta: float) -> void:
	_float_time += delta

	position.y = _starting_position.y + sin(
		_float_time * TAU * float_frequency
	) * float_height


func _handle_border_flash_delay_timeout() -> void:
	highlight_border.visible = !highlight_border.visible


func _handle_border_flash_duration_timeout() -> void:
	border_flash_delay_timer.stop()
	highlight_border.visible = false
