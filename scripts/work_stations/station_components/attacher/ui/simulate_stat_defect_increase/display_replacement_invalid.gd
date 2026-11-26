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
@export var travel_distance: float = 500.0
@export var travel_duration: float = 0.3
@export var travel_delay: float = 0.5
@export var inital_delay : float = 0.5

var stats: Array[String] = [
	'strength',
	'intelligence',
	'community',
]

var cinematic_tween: Tween


func _ready() -> void:
	_reset()


func _display() -> void:

	_reset()
	

	var main_stat_replacement_state: Dictionary[String, StatJarItem] = GLAttacherComponentBus.main_stat_replacement_state

	var active_indexes: Array[int] = []
	
	
	
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

		clean_bar.max_value = IVCellCreator.max_stat_value
		clean_bar.value = replacement_stat.value

		defect_bar.max_value = IVCellCreator.max_stat_value
		defect_bar.value = replacement_stat.defect

		active_indexes.append(index)

	# no replacements found
	if active_indexes.is_empty():
		push_error('No replacements found, however failed')
		_end()
		return

	_start_cinematic(active_indexes)


func _start_cinematic(active_indexes: Array[int]) -> void:

	cinematic_tween = create_tween()

	# initial delay
	cinematic_tween.tween_interval(inital_delay)

	for i in range(active_indexes.size()):

		var index: int = active_indexes[i]
		var stat_parent: Control = stat_replacement_parents[index]

		# play whoosh before each replacement moves
		cinematic_tween.tween_callback(
			func(): GLAttacherComponentBus.emit_signal(
				'play_sound', 'replacement_whoosh'
			)
		)

		# move replacement left
		cinematic_tween.tween_property(
			stat_parent,
			"position:x",
			-travel_distance,
			travel_duration
		).as_relative().set_trans(
			Tween.TRANS_QUAD
		).set_ease(
			Tween.EASE_IN
		)

		# fade out while traveling
		cinematic_tween.parallel().tween_property(
			stat_parent,
			"modulate:a",
			0.0,
			travel_duration
		)

		# delay only if another replacement remains
		if i < active_indexes.size() - 1:
			cinematic_tween.tween_interval(travel_delay)

	# finish cinematic
	cinematic_tween.tween_callback(_end)


func _end() -> void:
	parent_simulation._handle_replacement_cinnamtic_ended()


func _reset() -> void:

	if cinematic_tween and cinematic_tween.is_valid():
		cinematic_tween.kill()

	stat_replacements_parent_container.modulate.a = 1.0

	# reset individual replacements
	for stat_parent in stat_replacement_parents:
		stat_parent.visible = true
		stat_parent.modulate.a = 0.0

	# restore original positions through VBox layout
	stat_replacements_parent_container.queue_sort()
