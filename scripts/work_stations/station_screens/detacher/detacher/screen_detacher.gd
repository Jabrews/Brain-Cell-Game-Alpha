extends Node

## Parent components
@onready var disabled_stat_parent: Control = $Disabled
@onready var add_a_cell_parent: Control = $AddACell
@onready var stats_parent: Control = $Stats
@onready var detach_success_parent : Control = $DetachSuccess
@onready var detach_failed_parent : Control = $DetachFailed

## Stat display
# Labels
@onready var valid_label: Label = $Stats/ValidityLabels/Valid
@onready var invalid_label: Label = $Stats/ValidityLabels/Invalid
@onready var cell_name_label: Label = $Stats/CellNameHeader/CellNameLabel

# Stats
@onready var bar_sprites: Array[Sprite2D] = [
	$Stats/Strength/Bar,
	$Stats/Intelligence/Bar,
	$Stats/Community/Bar
]

@onready var defect_bars: Array[TextureProgressBar] = [
	$Stats/Strength/DefectBar,
	$Stats/Intelligence/DefectBar,
	$Stats/Community/DefectBar
]

@onready var disabled_parents: Array[Control] = [
	$Stats/Strength/DisabledParent,
	$Stats/Intelligence/DisabledParent,
	$Stats/Community/DisabledParent
]

@onready var hidden_parents: Array[Control] = [
	$Stats/Strength/HiddenParent,
	$Stats/Intelligence/HiddenParent,
	$Stats/Community/HiddenParent
]

@onready var active_borders: Array[TextureRect] = [
	$Stats/Strength/ActiveBorder,
	$Stats/Intelligence/ActiveBorder,
	$Stats/Community/ActiveBorder
]

func _ready() -> void:
	GLDetacherComponentBus.connect('show_success_screen', _handle_show_success_screen)
	GLDetacherComponentBus.connect('show_failed_screen', _handle_show_failed_screen)


func _refresh(
	enabled: bool,
	loaded_cell: BrainCell,
	stat_selected_index: int,
	stat_valid: bool
) -> void:
	disabled_stat_parent.visible = false
	add_a_cell_parent.visible = false
	stats_parent.visible = false

	if not enabled:
		disabled_stat_parent.visible = true
		return

	if not loaded_cell:
		add_a_cell_parent.visible = true
		return

	stats_parent.visible = true

	display_stats(loaded_cell)

	valid_label.visible = stat_valid
	invalid_label.visible = not stat_valid
	cell_name_label.text = loaded_cell.name

	for active_border: TextureRect in active_borders:
		active_border.visible = false

	if stat_selected_index >= 0 and stat_selected_index < active_borders.size():
		active_borders[stat_selected_index].visible = true


func display_stats(loaded_cell: BrainCell) -> void:
	var stat_types: Array[String] = [
		"strength",
		"intelligence",
		"community"
	]

	var max_stat_value: float = IVCellCreator.max_stat_value

	for stat_index: int in range(stat_types.size()):
		var stat: BrainCellStat = loaded_cell.get_stat(stat_types[stat_index])
		var bar_sprite: Sprite2D = bar_sprites[stat_index]
		var defect_bar: TextureProgressBar = defect_bars[stat_index]
		var disabled_parent: Control = disabled_parents[stat_index]
		var hidden_parent: Control = hidden_parents[stat_index]

		disabled_parent.visible = false
		hidden_parent.visible = false

		if not stat.enabled:
			disabled_parent.visible = true
			continue

		if stat.hidden:
			hidden_parent.visible = true
			continue

		bar_sprite.material.set_shader_parameter(
			"prisoner_value",
			stat.value / max_stat_value
		)

		defect_bar.max_value = max_stat_value
		defect_bar.value = stat.defect

func _handle_show_success_screen() : 
	detach_success_parent.visible = true
	await get_tree().create_timer(4.0).timeout
	detach_success_parent.visible = false 
	
	
func _handle_show_failed_screen() : 
	detach_failed_parent.visible = true
	await get_tree().create_timer(4.0).timeout
	detach_failed_parent.visible = false 
