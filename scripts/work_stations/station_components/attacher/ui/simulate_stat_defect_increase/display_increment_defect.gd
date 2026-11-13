
extends Node

# visual components
@onready var defect_bars: Array[TextureProgressBar] = [
	$"../AttacherBars/Strength/DefectBar",
	$"../AttacherBars/Intelligence/DefectBar",
	$"../AttacherBars/Community/DefectBar"
]

@onready var burst_hidden_sprites: Array[Sprite2D] = [
	$"../AttacherBars/Strength/BurstWarningParent/HiddenSprite",
	$"../AttacherBars/Intelligence/BurstWarningParent/HiddenSprite",
	$"../AttacherBars/Community/BurstWarningParent/HiddenSprite"
]

@onready var flesh_bug_sprites: Array[Sprite2D] = [
	$"../AttacherBars/Strength/BurstWarningParent/FleshBug",
	$"../AttacherBars/Intelligence/BurstWarningParent/FleshBug",
	$"../AttacherBars/Community/BurstWarningParent/FleshBug"
]

@onready var burst_imminent_labels: Array[Label] = [
	$"../AttacherBars/Strength/BurstWarningParent/BurstImminentLabel",
	$"../AttacherBars/Intelligence/BurstWarningParent/BurstImminentLabel",
	$"../AttacherBars/Community/BurstWarningParent/BurstImminentLabel"
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

	for sprite in burst_hidden_sprites:
		sprite.material = sprite.material.duplicate()

	for sprite in flesh_bug_sprites:
		sprite.material = sprite.material.duplicate()

	_reset_sprites()


func _display(defect_amount_to_increase: Dictionary[String, int]) -> void:
	display_session += 1

	increment_stat_timer.stop()

	# Stop previous animations
	for tween in reveal_tweens:
		if tween and tween.is_running():
			tween.kill()

	reveal_tweens.clear()
	burst_triggered = [false, false, false]

	_reset_sprites()

	remaining_increases = defect_amount_to_increase.duplicate()

	increment_stat_timer.wait_time = increment_interval

	if _all_increases_finished():
		_finish_after_reveals(display_session)
	else:
		increment_stat_timer.start()


func _handle_increment_stat_timeout() -> void:
	for index in range(stats.size()):
		var stat_type: String = stats[index]
		var remaining: int = remaining_increases.get(stat_type, 0)

		if remaining <= 0:
			continue

		var defect_bar: TextureProgressBar = defect_bars[index]

		# Increase defect by 1
		var next_value: float = defect_bar.value + 1.0
		defect_bar.value = next_value

		remaining_increases[stat_type] = remaining - 1

		# Trigger burst when reaching maximum defect
		if next_value >= IVCellCreator.max_stat_value:
			if not burst_triggered[index]:
				burst_triggered[index] = true
				_display_burst(index)

	# All defect increments completed
	if _all_increases_finished():
		increment_stat_timer.stop()
		_finish_after_reveals(display_session)


func _all_increases_finished() -> bool:
	for stat_type in stats:
		if remaining_increases.get(stat_type, 0) > 0:
			return false

	return true


func _display_burst(index: int) -> void:
	var burst_sprite: Sprite2D = burst_hidden_sprites[index]
	var flesh_sprite: Sprite2D = flesh_bug_sprites[index]
	var burst_imminent_label: Label = burst_imminent_labels[index]

	burst_imminent_label.visible = false

	# Reveal burst warning
	var burst_tween: Tween = create_tween()
	reveal_tweens.append(burst_tween)

	burst_tween.tween_property(
		burst_sprite.material,
		"shader_parameter/reveal_progress",
		1.0,
		burst_reveal_duration
	)

	# Reveal flesh bug after burst warning
	var flesh_tween: Tween = create_tween()
	reveal_tweens.append(flesh_tween)

	flesh_tween.tween_interval(
		burst_reveal_duration + flesh_bug_delay
	)

	flesh_tween.tween_property(
		flesh_sprite.material,
		"shader_parameter/reveal_progress",
		1.0,
		flesh_bug_reveal_duration
	)

	# Show label after flesh bug fully materializes
	flesh_tween.tween_callback(
		func(): burst_imminent_label.visible = true
	)

	# Keep flesh bug fully visible before ending
	flesh_tween.tween_interval(flesh_bug_hold_duration)


func _finish_after_reveals(session: int) -> void:
	# Wait for all reveal animations
	for tween in reveal_tweens:
		if session != display_session:
			return

		if tween and tween.is_running():
			await tween.finished

	if session != display_session:
		return

	# Additional pause after everything finishes
	if simulation_end_delay > 0.0:
		await get_tree().create_timer(simulation_end_delay).timeout

	if session != display_session:
		return

	parent_simulate._end()


func _reset_sprites() -> void:
	for sprite in burst_hidden_sprites:
		(sprite.material as ShaderMaterial).set_shader_parameter(
			"reveal_progress", 0.0
		)

	for sprite in flesh_bug_sprites:
		(sprite.material as ShaderMaterial).set_shader_parameter(
			"reveal_progress", 0.0
		)

	for label in burst_imminent_labels:
		label.visible = false
