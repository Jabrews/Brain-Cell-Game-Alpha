extends Node

# visual components
@onready var defect_bars: Array[TextureRect] = [
	$"../Content/MainStats/Strength/DefaultInfoContainer/DefectBar",
	$"../Content/MainStats/Intelligence/DefaultInfoContainer/DefectBar",
	$"../Content/MainStats/Community/DefaultInfoContainer/DefectBar",
]

@onready var burst_warning_bgs: Array[TextureRect] = [
	$"../Content/MainStats/Strength/BurstWarningParent/WarningBGRect",
	$"../Content/MainStats/Intelligence/BurstWarningParent/WarningBGRect",
	$"../Content/MainStats/Community/BurstWarningParent/WarningBGRect",
]

@onready var flesh_bug_rects_1: Array[TextureRect] = [
	$"../Content/MainStats/Strength/BurstWarningParent/HBoxContainer/FleshBug",
	$"../Content/MainStats/Intelligence/BurstWarningParent/HBoxContainer/FleshBug",
	$"../Content/MainStats/Community/BurstWarningParent/HBoxContainer/FleshBug",
]

@onready var flesh_bug_rects_2: Array[TextureRect] = [
	$"../Content/MainStats/Strength/BurstWarningParent/HBoxContainer/FleshBug2",
	$"../Content/MainStats/Intelligence/BurstWarningParent/HBoxContainer/FleshBug2",
	$"../Content/MainStats/Community/BurstWarningParent/HBoxContainer/FleshBug2",
]

@onready var burst_imminent_labels: Array[Label] = [
	$"../Content/MainStats/Strength/BurstWarningParent/HBoxContainer/BurstImminentLabel",
	$"../Content/MainStats/Intelligence/BurstWarningParent/HBoxContainer/BurstImminentLabel",
	$"../Content/MainStats/Community/BurstWarningParent/HBoxContainer/BurstImminentLabel",
]


# components
@onready var parent_simulation : Control = $".."
@onready var increment_stat_timer: Timer = $IncrementStatTimer

# settings
@export var increment_interval: float = 0.01
@export var burst_reveal_duration: float = 1.0
@export var flesh_bug_reveal_duration: float = 0.3
@export var flesh_bug_delay: float = 0.2
@export var flesh_bug_hold_duration: float = 0.3
@export var simulation_end_delay: float = 1.2

var stats: Array[String] = [
	'strength',
	'intelligence',
	'community'
]

var remaining_increases: Dictionary[String, int] = {}
var burst_triggered: Array[bool] = [false, false, false]
var reveal_tweens: Array[Tween] = []

var display_session: int = 0


func _ready() -> void:
	increment_stat_timer.timeout.connect(_handle_increment_stat_timeout)

	for rect in burst_warning_bgs:
		rect.material = rect.material.duplicate()

	for rect in flesh_bug_rects_1:
		rect.material = rect.material.duplicate()

	for rect in flesh_bug_rects_2:
		rect.material = rect.material.duplicate()

	_reset_rects()


func _display(defect_amount_to_increase: Dictionary[String, int]) -> void:
	display_session += 1

	increment_stat_timer.stop()

	# stop previous animations
	for tween in reveal_tweens:
		if tween and tween.is_valid():
			tween.kill()

	reveal_tweens.clear()
	burst_triggered = [false, false, false]

	_reset_rects()

	remaining_increases = defect_amount_to_increase.duplicate()

	increment_stat_timer.wait_time = increment_interval

	if _all_increases_finished():
		_finish_after_reveals(display_session)
	else:
		GLAttacherComponentBus.emit_signal('play_sound', 'loop_beep_start')
		increment_stat_timer.start()


func _handle_increment_stat_timeout() -> void:
	for index in range(stats.size()):
		var stat_type: String = stats[index]
		var remaining: int = remaining_increases.get(stat_type, 0)

		if remaining <= 0:
			continue

		var defect_bar: TextureRect = defect_bars[index]
		var material: ShaderMaterial = defect_bar.material as ShaderMaterial
		var max_value: float = float(IVCellCreator.max_stat_value)

		# read current prior defect
		var prior_value: float = float(
			material.get_shader_parameter("prior_defect_value")
		) * max_value

		# increase prior defect by 1
		var next_value: float = minf(
			prior_value + 1.0,
			max_value
		)

		material.set_shader_parameter(
			"prior_defect_value",
			next_value / max_value
		)

		remaining_increases[stat_type] = remaining - 1

		# trigger burst when reaching maximum defect
		if is_equal_approx(next_value, max_value):
			if not burst_triggered[index]:
				burst_triggered[index] = true
				_display_burst(index)

	# all defect increments completed
	if _all_increases_finished():
		increment_stat_timer.stop()

		GLAttacherComponentBus.emit_signal('play_sound', 'loop_beep_stop')

		_finish_after_reveals(display_session)


func _all_increases_finished() -> bool:
	for stat_type in stats:
		if remaining_increases.get(stat_type, 0) > 0:
			return false

	return true


func _display_burst(index: int) -> void:
	var burst_warning_bg: TextureRect = burst_warning_bgs[index]
	var flesh_bug_rect_1: TextureRect = flesh_bug_rects_1[index]
	var flesh_bug_rect_2: TextureRect = flesh_bug_rects_2[index]
	var burst_imminent_label: Label = burst_imminent_labels[index]

	burst_imminent_label.modulate.a = 0.0

	# play hidden stat sound before revealing
	GLAttacherComponentBus.emit_signal(
		'play_sound',
		'burst_warning_hidden_stat'
	)

	var reveal_tween: Tween = create_tween()
	reveal_tweens.append(reveal_tween)

	# 1. reveal burst warning background
	reveal_tween.tween_property(
		burst_warning_bg.material,
		"shader_parameter/reveal_progress",
		1.0,
		burst_reveal_duration
	)

	# 2. show burst imminent label
	reveal_tween.tween_callback(
		func(): burst_imminent_label.modulate.a = 1.0
	)

	# delay before revealing bugs
	reveal_tween.tween_interval(flesh_bug_delay)

	# play bug sound
	reveal_tween.tween_callback(
		func(): GLAttacherComponentBus.emit_signal(
			'play_sound',
			'burst_warning_bug'
		)
	)

	# 3. reveal first flesh bug
	reveal_tween.tween_property(
		flesh_bug_rect_1.material,
		"shader_parameter/reveal_progress",
		1.0,
		flesh_bug_reveal_duration
	)

	# reveal second flesh bug simultaneously
	reveal_tween.parallel().tween_property(
		flesh_bug_rect_2.material,
		"shader_parameter/reveal_progress",
		1.0,
		flesh_bug_reveal_duration
	)

	# hold completed reveal
	reveal_tween.tween_interval(flesh_bug_hold_duration)


func _finish_after_reveals(session: int) -> void:
	# wait for all reveal animations
	while session == display_session:
		var revealing: bool = false

		for tween in reveal_tweens:
			if tween and tween.is_running():
				revealing = true
				break

		if not revealing:
			break

		await get_tree().process_frame

	if session != display_session:
		return

	# additional pause after everything finishes
	if simulation_end_delay > 0.0:
		await get_tree().create_timer(simulation_end_delay).timeout

	if session != display_session:
		return

	parent_simulation._handle_increment_cinnamatic_ended()
	
	_reset_rects()


func _reset_rects() -> void:
	# reset burst warning backgrounds
	for rect in burst_warning_bgs:
		rect.visible = true
		rect.modulate.a = 1.0

		(rect.material as ShaderMaterial).set_shader_parameter(
			"reveal_progress",
			0.0
		)

	# reset first flesh bug rects
	for rect in flesh_bug_rects_1:
		rect.visible = true
		rect.modulate.a = 1.0

		(rect.material as ShaderMaterial).set_shader_parameter(
			"reveal_progress",
			0.0
		)

	# reset second flesh bug rects
	for rect in flesh_bug_rects_2:
		rect.visible = true
		rect.modulate.a = 1.0

		(rect.material as ShaderMaterial).set_shader_parameter(
			"reveal_progress",
			0.0
		)

	# reset labels without changing container layout
	for label in burst_imminent_labels:
		label.visible = true
		label.modulate.a = 0.0
