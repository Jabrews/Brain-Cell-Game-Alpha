extends Node

# components
@onready var parent_simulation: Control = $".."

# visual components
@onready var stat_replacements_parent_container: VBoxContainer = $"../Content/StatReplacements"

@onready var stat_replacement_parents: Array[Control] = [
	$"../Content/StatReplacements/Strength",
	$"../Content/StatReplacements/Intelligence",
	$"../Content/StatReplacements/Community",
]

@onready var clean_bars: Array[TextureProgressBar] = [
	$"../Content/StatReplacements/Strength/ReplacementInfoContainer/DefaultInfoContainer/CleanBar",
	$"../Content/StatReplacements/Intelligence/ReplacementInfoContainer/DefaultInfoContainer/CleanBar",
	$"../Content/StatReplacements/Community/ReplacementInfoContainer/DefaultInfoContainer/CleanBar",
]

@onready var defect_bars: Array[TextureProgressBar] = [
	$"../Content/StatReplacements/Strength/ReplacementInfoContainer/DefaultInfoContainer/DefectBar",
	$"../Content/StatReplacements/Intelligence/ReplacementInfoContainer/DefaultInfoContainer/DefectBar",
	$"../Content/StatReplacements/Community/ReplacementInfoContainer/DefaultInfoContainer/DefectBar",
]

# settings
@export var flash_color: Color = Color(1.0, 0.2, 0.2, 1.0)
@export var flash_duration: float = 0.15
@export var flash_count: int = 3
@export var scale_multiplier: float = 1.1

@export var travel_distance: float = 500.0
@export var travel_duration: float = 1.0
@export var travel_delay: float = 3

var stats: Array[String] = [
	'strength',
	'intelligence',
	'community',
]

var parent_initial_position: Vector2
var original_scales: Array[Vector2] = []

var cinematic_tween: Tween


func _ready() -> void:
	parent_initial_position = stat_replacements_parent_container.position

	for stat_parent in stat_replacement_parents:
		original_scales.append(stat_parent.scale)
		stat_parent.pivot_offset = stat_parent.size / 2.0

	_reset()


func _display() -> void:

	_reset()

	var main_stat_replacement_state: Dictionary[String, StatJarItem] = GLAttacherComponentBus.main_stat_replacement_state

	var active_indexes: Array[int] = []

	# display assigned replacement stats
	for index in range(stats.size()):

		var stat_type: String = stats[index]
		var replacement_item: StatJarItem = main_stat_replacement_state[stat_type]

		if not replacement_item:
			continue

		var replacement_stat: BrainCellStat = replacement_item.corrisponding_stat

		var stat_parent: Control = stat_replacement_parents[index]
		var clean_bar: TextureProgressBar = clean_bars[index]
		var defect_bar: TextureProgressBar = defect_bars[index]

		# display replacement
		stat_parent.modulate.a = 1.0
		stat_parent.pivot_offset = stat_parent.size / 2.0

		clean_bar.max_value = IVCellCreator.max_stat_value
		clean_bar.value = replacement_stat.value

		defect_bar.max_value = IVCellCreator.max_stat_value
		defect_bar.value = replacement_stat.defect

		active_indexes.append(index)

	# no replacements found
	if active_indexes.is_empty():
		push_error('no replacements found, however failed, ')
		return

	_start_cinematic(active_indexes)


func _start_cinematic(active_indexes: Array[int]) -> void:

	cinematic_tween = create_tween()

	cinematic_tween.set_trans(Tween.TRANS_SINE)
	cinematic_tween.set_ease(Tween.EASE_IN_OUT)

	# flash and scale all active replacements
	for i in range(flash_count):

		# increase scale and flash red
		for index in active_indexes:
			var stat_parent: Control = stat_replacement_parents[index]

			cinematic_tween.parallel().tween_property(
				stat_parent,
				"modulate",
				flash_color,
				flash_duration
			)

			cinematic_tween.parallel().tween_property(
				stat_parent,
				"scale",
				original_scales[index] * scale_multiplier,
				flash_duration
			)

		# return to original color and scale
		cinematic_tween.chain()

		for index in active_indexes:
			var stat_parent: Control = stat_replacement_parents[index]

			cinematic_tween.parallel().tween_property(
				stat_parent,
				"modulate",
				Color.WHITE,
				flash_duration
			)

			cinematic_tween.parallel().tween_property(
				stat_parent,
				"scale",
				original_scales[index],
				flash_duration
			)

		cinematic_tween.chain()

	# brief pause before removing replacements
	cinematic_tween.tween_interval(travel_delay)

	# move entire replacement container left
	var final_position: Vector2 = (
		parent_initial_position - Vector2(travel_distance, 0.0)
	)

	cinematic_tween.tween_property(
		stat_replacements_parent_container,
		"position",
		final_position,
		travel_duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# fade out while traveling
	cinematic_tween.parallel().tween_property(
		stat_replacements_parent_container,
		"modulate:a",
		0.0,
		travel_duration
	)

	# finish cinematic
	cinematic_tween.tween_callback(_end)


func _end() -> void:
	parent_simulation._handle_replacement_cinnamtic_ended()


func _reset() -> void:

	if cinematic_tween and cinematic_tween.is_valid():
		cinematic_tween.kill()

	# reset container
	stat_replacements_parent_container.position = parent_initial_position
	stat_replacements_parent_container.modulate.a = 1.0

	# reset individual replacements
	for index in range(stats.size()):
		var stat_parent: Control = stat_replacement_parents[index]

		stat_parent.modulate = Color(1.0, 1.0, 1.0, 0.0)
		stat_parent.scale = original_scales[index]
