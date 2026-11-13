
extends Node

# components
@onready var grid_container_parent: GridContainer = $"../../../../AttacherUI/JarItemCatalog/CenterContainer/ScrollContainer/GridContainerLeft"
@onready var parent_attacher: Node3D = $"../../../.."

# refresh up, down
@onready var exit_btn: ColorRect = $"../../../../AttacherUI/ExitHeader/ExitBtn"
@onready var confirm_btn: ColorRect = $"../../../../AttacherUI/InteractFooter/ConfirmBtn/BtnBg"

# refresh right
@onready var attacher_box_display_bg : TextureRect = $"../../../../AttacherUI/StatMainView/AttacherBox/DisplayBackground"
@onready var strength_default_detect_rect: ColorRect = $"../../../../AttacherUI/StatMainView/Stats/Strength/DefaultDetectRect"
@onready var strength_replacement_failure_rate_bg: ColorRect = $"../../../../AttacherUI/StatMainView/Stats/Strength/StatReplacement/PenalityFailureRate/BG"
@onready var strength_replacement_remove_btn_bg: TextureRect = $"../../../../AttacherUI/StatMainView/Stats/Strength/StatReplacement/RemoveBtn/BtnBG"


func _refresh() -> void:
	await get_tree().process_frame

	_refresh_up_down()
	_refresh_left_right()


func _refresh_up_down() -> void:
	var available_items: Array[Node] = []

	# Collect only unused jar items
	for jar_item_parent in grid_container_parent.get_children():
		var jar_item_bg: TextureRect = jar_item_parent.bg
		var delete_btn_bg: Control = jar_item_parent.delete_btn

		# Disable used items
		if jar_item_parent.is_used:
			if jar_item_bg.has_focus():
				jar_item_bg.release_focus()

			if delete_btn_bg.has_focus():
				delete_btn_bg.release_focus()

			jar_item_bg.focus_mode = Control.FOCUS_NONE
			delete_btn_bg.focus_mode = Control.FOCUS_NONE

			# Clear old navigation
			jar_item_bg.focus_neighbor_top = NodePath()
			jar_item_bg.focus_neighbor_bottom = NodePath()
			jar_item_bg.focus_neighbor_right = NodePath()

			delete_btn_bg.focus_neighbor_top = NodePath()
			delete_btn_bg.focus_neighbor_bottom = NodePath()
			delete_btn_bg.focus_neighbor_left = NodePath()
			delete_btn_bg.focus_neighbor_right = NodePath()

			continue

		# Enable unused items
		jar_item_bg.focus_mode = Control.FOCUS_ALL
		delete_btn_bg.focus_mode = Control.FOCUS_ALL

		available_items.append(jar_item_parent)

	# Connect available items vertically
	for index in range(available_items.size()):
		var jar_item_parent: Node = available_items[index]

		var jar_item_bg: TextureRect = jar_item_parent.bg
		var delete_btn_bg: Control = jar_item_parent.delete_btn

		# Default neighbors
		var top_neighbor: Control = exit_btn
		var bottom_neighbor: Control = confirm_btn

		# Previous available jar item
		if index > 0:
			top_neighbor = available_items[index - 1].bg

		# Next available jar item
		if index < available_items.size() - 1:
			bottom_neighbor = available_items[index + 1].bg

		# Both controls share vertical navigation
		jar_item_bg.focus_neighbor_top = top_neighbor.get_path()
		jar_item_bg.focus_neighbor_bottom = bottom_neighbor.get_path()

		delete_btn_bg.focus_neighbor_top = top_neighbor.get_path()
		delete_btn_bg.focus_neighbor_bottom = bottom_neighbor.get_path()

		# Horizontal navigation
		jar_item_bg.focus_neighbor_right = delete_btn_bg.get_path()
		delete_btn_bg.focus_neighbor_left = jar_item_bg.get_path()


func _refresh_left_right() -> void:
	var loaded_cell: BrainCell = parent_attacher._get_loaded_cell()
	var failure_rate_enabled: bool = parent_attacher.failure_rate_enabled
	var strength_main_stat_replacement: StatJarItem = GLAttacherComponentBus.main_stat_replacement_state['strength']

	var right_neighbor: Control

	# No cell loaded
	if not loaded_cell:
		right_neighbor = attacher_box_display_bg

	# Strength stat has replacement
	elif strength_main_stat_replacement:
		if failure_rate_enabled:
			right_neighbor = strength_replacement_failure_rate_bg
		else:
			right_neighbor = exit_btn

	# No strength replacement
	else:
		right_neighbor = strength_default_detect_rect

	# Apply right navigation only to unused delete buttons
	for jar_item_parent in grid_container_parent.get_children():
		var delete_btn_bg: Control = jar_item_parent.delete_btn

		if jar_item_parent.is_used:
			delete_btn_bg.focus_neighbor_right = NodePath()
			continue

		delete_btn_bg.focus_neighbor_right = right_neighbor.get_path()
