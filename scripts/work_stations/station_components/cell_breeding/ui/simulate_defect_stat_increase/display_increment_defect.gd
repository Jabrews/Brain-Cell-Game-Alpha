
extends Node

# defect bars
@onready var l_defect_bars: Array[Sprite2D] = [
	$"../BreederBars/Left/Strength/DefectBar",
	$"../BreederBars/Left/Intelligence/DefectBar",
	$"../BreederBars/Left/Community/DefectBar"
]
@onready var r_defect_bars: Array[Sprite2D] = [
	$"../BreederBars/Right/Strength/DefectBar",
	$"../BreederBars/Right/Intelligence/DefectBar",
	$"../BreederBars/Right/Community/DefectBar"
]

# burst hidden sprites
@onready var l_burst_hidden_sprites: Array[Sprite2D] = [
	$"../BreederBars/Left/Strength/BurstWarningParent/HiddenSprite",
	$"../BreederBars/Left/Intelligence/BurstWarningParent/HiddenSprite",
	$"../BreederBars/Left/Community/BurstWarningParent/HiddenSprite"
]
@onready var r_burst_hidden_sprites: Array[Sprite2D] = [
	$"../BreederBars/Right/Strength/BurstWarningParent/HiddenSprite",
	$"../BreederBars/Right/Intelligence/BurstWarningParent/HiddenSprite",
	$"../BreederBars/Right/Community/BurstWarningParent/HiddenSprite"
]

# burst flesh bug
@onready var l_flesh_bug_sprites: Array[Sprite2D] = [
	$"../BreederBars/Left/Strength/BurstWarningParent/FleshBug",
	$"../BreederBars/Left/Intelligence/BurstWarningParent/FleshBug",
	$"../BreederBars/Left/Community/BurstWarningParent/FleshBug"
]
@onready var r_flesh_bug_sprites: Array[Sprite2D] = [
	$"../BreederBars/Right/Strength/BurstWarningParent/FleshBug",
	$"../BreederBars/Right/Intelligence/BurstWarningParent/FleshBug",
	$"../BreederBars/Right/Community/BurstWarningParent/FleshBug"
]

# burst labels
@onready var l_burst_imminent_labels: Array[Label] = [
	$"../BreederBars/Left/Strength/BurstWarningParent/BurstImminentLabel",
	$"../BreederBars/Left/Intelligence/BurstWarningParent/BurstImminentLabel",
	$"../BreederBars/Left/Community/BurstWarningParent/BurstImminentLabel"
]
@onready var r_burst_imminent_labels: Array[Label] = [
	$"../BreederBars/Right/Strength/BurstWarningParent/BurstImminentLabel",
	$"../BreederBars/Right/Intelligence/BurstWarningParent/BurstImminentLabel",
	$"../BreederBars/Right/Community/BurstWarningParent/BurstImminentLabel"
]

# components
@onready var parent_simulate: Control = $".."
@onready var increment_stat_timer: Timer = $IncrementStatTimer

# settings
@export var increment_interval: float = 0.03
@export var burst_reveal_duration: float = 1.0
@export var flesh_bug_reveal_duration: float = 0.3
@export var flesh_bug_delay: float = 0.2
@export var flesh_bug_hold_duration: float = 0.3
@export var simulation_end_delay: float = 0.7

var stats: Array[String] = [
	"strength",
	"intelligence",
	"community"
]

var remaining_increases: Dictionary[String, Dictionary] = {}

var l_burst_triggered: Array[bool] = [false, false, false]
var r_burst_triggered: Array[bool] = [false, false, false]

var reveal_tweens: Array[Tween] = []

var display_session: int = 0
var finishing: bool = false


func _ready() -> void:
	increment_stat_timer.timeout.connect(_handle_increment_stat_timeout)

	# Duplicate materials so each burst animates independently
	for sprite in l_burst_hidden_sprites + r_burst_hidden_sprites:
		if sprite.material:
			sprite.material = sprite.material.duplicate()

	for sprite in l_flesh_bug_sprites + r_flesh_bug_sprites:
		if sprite.material:
			sprite.material = sprite.material.duplicate()

	_reset_sprites()


func _display(
	defect_amount_to_increase: Dictionary[String, Dictionary]
) -> void:

	display_session += 1
	finishing = false

	increment_stat_timer.stop()

	# Stop previous animations
	for tween in reveal_tweens:
		if tween and tween.is_running():
			tween.kill()

	reveal_tweens.clear()

	l_burst_triggered = [false, false, false]
	r_burst_triggered = [false, false, false]

	_reset_sprites()

	# Store increments separately
	var left_increases: Dictionary = defect_amount_to_increase["left"]
	var right_increases: Dictionary = defect_amount_to_increase["right"]

	remaining_increases = {
		"left": left_increases.duplicate(),
		"right": right_increases.duplicate()
	}

	increment_stat_timer.wait_time = maxf(increment_interval, 0.001)

	GLAttacherComponentBus.emit_signal(
		"play_sound",
		"loop_beep_start"
	)

	# Trigger bursts for stats already at maximum
	for side in ["left", "right"]:
		var defect_bars: Array[Sprite2D] = _get_defect_bars(side)

		for index in range(stats.size()):
			var defect_bar: Sprite2D = defect_bars[index]

			if not defect_bar.is_visible_in_tree():
				continue

			var material: ShaderMaterial = defect_bar.material as ShaderMaterial

			var prior_value: float = float(
				material.get_shader_parameter("prior_defect_value")
			)

			if prior_value >= 1.0:
				_trigger_burst(side, index)

	if _all_increases_finished():
		_begin_finish()
	else:
		increment_stat_timer.start()


func _handle_increment_stat_timeout() -> void:
	var max_value: float = float(IVCellCreator.max_stat_value)

	for side in ["left", "right"]:
		var defect_bars: Array[Sprite2D] = _get_defect_bars(side)
		var side_increases: Dictionary = remaining_increases[side]

		for index in range(stats.size()):
			var stat_type: String = stats[index]
			var remaining: int = side_increases.get(stat_type, 0)

			if remaining <= 0:
				continue

			var defect_bar: Sprite2D = defect_bars[index]
			var material: ShaderMaterial = defect_bar.material as ShaderMaterial

			# Read current prior defect
			var prior_value: float = float(
				material.get_shader_parameter("prior_defect_value")
			) * max_value

			# Increase prior defect by 1
			var next_value: float = minf(
				prior_value + 1.0,
				max_value
			)

			material.set_shader_parameter(
				"prior_defect_value",
				next_value / max_value
			)

			side_increases[stat_type] = remaining - 1

			# Trigger burst when reaching maximum
			if next_value >= max_value and defect_bar.is_visible_in_tree():
				_trigger_burst(side, index)

	# All defect increments completed
	if _all_increases_finished():
		increment_stat_timer.stop()
		_begin_finish()


func _get_defect_bars(side: String) -> Array[Sprite2D]:
	if side == "left":
		return l_defect_bars

	return r_defect_bars


func _trigger_burst(side: String, index: int) -> void:

	if side == "left":
		if l_burst_triggered[index]:
			return

		l_burst_triggered[index] = true
	else:
		if r_burst_triggered[index]:
			return

		r_burst_triggered[index] = true

	_display_burst(side, index)


func _all_increases_finished() -> bool:

	for side in ["left", "right"]:
		var side_increases: Dictionary = remaining_increases.get(side, {})

		for stat_type in stats:
			if side_increases.get(stat_type, 0) > 0:
				return false

	return true


func _begin_finish() -> void:
	if finishing:
		return

	finishing = true

	GLAttacherComponentBus.emit_signal(
		"play_sound",
		"loop_beep_stop"
	)

	_finish_after_reveals(display_session)


func _display_burst(side: String, index: int) -> void:

	var burst_sprite: Sprite2D
	var flesh_sprite: Sprite2D
	var burst_imminent_label: Label

	if side == "left":
		burst_sprite = l_burst_hidden_sprites[index]
		flesh_sprite = l_flesh_bug_sprites[index]
		burst_imminent_label = l_burst_imminent_labels[index]
	else:
		burst_sprite = r_burst_hidden_sprites[index]
		flesh_sprite = r_flesh_bug_sprites[index]
		burst_imminent_label = r_burst_imminent_labels[index]

	burst_imminent_label.visible = false

	# Play warning sound
	GLAttacherComponentBus.emit_signal(
		"play_sound",
		"burst_warning_hidden_stat"
	)

	# Reveal burst warning
	var burst_tween: Tween = create_tween()
	reveal_tweens.append(burst_tween)

	burst_tween.tween_property(
		burst_sprite.material,
		"shader_parameter/reveal_progress",
		1.0,
		burst_reveal_duration
	)

	# Reveal flesh bug after warning
	var flesh_tween: Tween = create_tween()
	reveal_tweens.append(flesh_tween)

	flesh_tween.tween_interval(
		burst_reveal_duration + flesh_bug_delay
	)

	# Play bug sound
	flesh_tween.tween_callback(
		func():
			GLAttacherComponentBus.emit_signal(
				"play_sound",
				"burst_warning_bug"
			)
	)

	# Reveal flesh bug
	flesh_tween.tween_property(
		flesh_sprite.material,
		"shader_parameter/reveal_progress",
		1.0,
		flesh_bug_reveal_duration
	)

	# Show label after reveal
	flesh_tween.tween_callback(
		func():
			burst_imminent_label.visible = true
	)

	# Hold after reveal
	flesh_tween.tween_interval(flesh_bug_hold_duration)


func _finish_after_reveals(session: int) -> void:

	# Wait for burst animations
	for tween in reveal_tweens:
		if session != display_session:
			return

		if tween and tween.is_running():
			await tween.finished

	if session != display_session:
		return

	# Final delay
	if simulation_end_delay > 0.0:
		await get_tree().create_timer(
			simulation_end_delay
		).timeout

	if session != display_session:
		return

	parent_simulate._end()


func _reset_sprites() -> void:

	for sprite in l_burst_hidden_sprites + r_burst_hidden_sprites:
		if sprite.material is ShaderMaterial:
			(sprite.material as ShaderMaterial).set_shader_parameter(
				"reveal_progress",
				0.0
			)

	for sprite in l_flesh_bug_sprites + r_flesh_bug_sprites:
		if sprite.material is ShaderMaterial:
			(sprite.material as ShaderMaterial).set_shader_parameter(
				"reveal_progress",
				0.0
			)

	for label in l_burst_imminent_labels + r_burst_imminent_labels:
		label.visible = false
