extends Node

## util helpers
@onready var get_ordered_jar_item: Node = $GetOrderedJarItem
@onready var get_main_stat_focus_target: Node = $GetMainStatFocusTarget


## visual components
@onready var catalog_parent: VBoxContainer = $"../../../AttacherUI/Content/JarItemCatalog/CenterContainer/ScrollContainer/CatalogParent"

@onready var parent_attacher: Node3D = $"../../.."

# header / footer
@onready var exit_btn_bg: ColorRect = $"../../../AttacherUI/Content/ExitHeader/HBoxContainer/ExitBtn/BG"
@onready var confirm_btn_bg: ColorRect = $"../../../AttacherUI/Content/InteractFooter/ButtonsHBox/ConfirmBtn/BtnBg"

# bottom section
@onready var attacher_box_display_bg: TextureRect = $"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/AttacherBox/DisplayBackground"
@onready var blood_type_view_bg: ColorRect = $"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/BloodTypeView/BG"
@onready var failure_chance_view_detect_rect: ColorRect = $"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/DetectRect"

## main stats
# str
@onready var strength_default_detect_rect: ColorRect = $"../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Strength/DefaultDetectRect"
@onready var strength_replacement_failure_rate_bg: ColorRect = $"../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Strength/StatReplacement/ReplacementInfoContainer/Header/PenalityFailureRate/BG"
@onready var strength_replacement_remove_btn_bg: TextureRect = $"../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Strength/StatReplacement/ReplacementInfoContainer/Header/RemoveBtn/BtnBG"

# int
@onready var intelligence_default_detect_rect: ColorRect = $"../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Intelligence/DefaultDetectRect"
@onready var intelligence_replacement_failure_rate_bg: ColorRect = $"../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Intelligence/StatReplacement/ReplacementInfoContainer/Header/PenalityFailureRate/BG"
@onready var intelligence_replacement_remove_btn_bg: TextureRect = $"../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Intelligence/StatReplacement/ReplacementInfoContainer/Header/RemoveBtn/BtnBG"

# com
@onready var community_default_detect_rect: ColorRect = $"../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Community/DefaultDetectRect"
@onready var community_replacement_failure_rate_bg: ColorRect = $"../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Community/StatReplacement/ReplacementInfoContainer/Header/PenalityFailureRate/BG"
@onready var community_replacement_remove_btn_bg: TextureRect = $"../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Community/StatReplacement/ReplacementInfoContainer/Header/RemoveBtn/BtnBG"



func _refresh() -> void:
	
	if GAMEInputTypeDetector.input_type != 'controller' : 
		return

	# main content
	refresh_jar_items()
	refresh_main_stats()

	# header / footer
	refresh_exit_btn()
	refresh_confirm_btn()

	# bottom section
	refresh_box()
	refresh_blood_type_view()
	refresh_failure_chance_view()


func refresh_jar_items() -> void:
	var children: Array[Control] = get_ordered_jar_item._get_items()
	var loaded_cell: BrainCell = parent_attacher._get_loaded_cell()

	var right_target: Control = attacher_box_display_bg

	if loaded_cell:
		right_target = get_main_stat_focus_target._get_target("strength")

	for i in range(children.size()):
		var jar_item: Control = children[i]
		var bg: TextureRect = jar_item.bg
		var delete_bg: ColorRect = jar_item.delete_btn_bg

		_reset_focus(bg)
		_reset_focus(delete_bg)

		bg.focus_mode = Control.FOCUS_ALL

		var above: Control = exit_btn_bg
		var below: Control = attacher_box_display_bg

		if i > 0:
			above = children[i - 1].bg

		if i < children.size() - 1:
			below = children[i + 1].bg

		# jar item background
		bg.focus_neighbor_top = bg.get_path_to(above)
		bg.focus_neighbor_bottom = bg.get_path_to(below)

		# right : delete btn if available
		var delete_available: bool = (
			not jar_item.is_used
			and jar_item.delete_btn.visible
			and delete_bg.visible
		)

		if delete_available:
			delete_bg.focus_mode = Control.FOCUS_ALL
			bg.focus_neighbor_right = bg.get_path_to(delete_bg)

		else:
			delete_bg.focus_mode = Control.FOCUS_NONE
			bg.focus_neighbor_right = bg.get_path_to(right_target)

		# delete button
		# all directions return to bg except right
		delete_bg.focus_neighbor_top = delete_bg.get_path_to(bg)
		delete_bg.focus_neighbor_bottom = delete_bg.get_path_to(bg)
		delete_bg.focus_neighbor_left = delete_bg.get_path_to(bg)
		delete_bg.focus_neighbor_right = delete_bg.get_path_to(right_target)


func refresh_exit_btn() -> void:
	_reset_focus(exit_btn_bg)

	var loaded_cell: BrainCell = parent_attacher._get_loaded_cell()

	var down_target: Control = attacher_box_display_bg
	var left_target: Control = exit_btn_bg

	# down : strength or box
	if loaded_cell:
		down_target = get_main_stat_focus_target._get_target("strength")

	# left : first jar item or itself
	var first_jar_item: Control = get_ordered_jar_item._get_ordered("first")

	if first_jar_item:
		left_target = first_jar_item.bg

	exit_btn_bg.focus_neighbor_bottom = exit_btn_bg.get_path_to(down_target)
	exit_btn_bg.focus_neighbor_left = exit_btn_bg.get_path_to(left_target)

	# top and right remain itself


func refresh_confirm_btn() -> void:
	_reset_focus(confirm_btn_bg)

	# up : always box
	confirm_btn_bg.focus_neighbor_top = confirm_btn_bg.get_path_to(attacher_box_display_bg)


func refresh_box() -> void:
	_reset_focus(attacher_box_display_bg)

	var loaded_cell: BrainCell = parent_attacher._get_loaded_cell()

	var left_target: Control = attacher_box_display_bg
	var right_target: Control = attacher_box_display_bg
	var up_target: Control = exit_btn_bg

	# cell loaded
	if loaded_cell:
		left_target = blood_type_view_bg
		right_target = failure_chance_view_detect_rect
		up_target = get_main_stat_focus_target._get_target("community")

	# no cell
	else:
		var last_jar_item: Control = get_ordered_jar_item._get_ordered("last")

		if last_jar_item:
			left_target = last_jar_item.bg

	attacher_box_display_bg.focus_neighbor_left = attacher_box_display_bg.get_path_to(left_target)
	attacher_box_display_bg.focus_neighbor_right = attacher_box_display_bg.get_path_to(right_target)
	attacher_box_display_bg.focus_neighbor_top = attacher_box_display_bg.get_path_to(up_target)
	attacher_box_display_bg.focus_neighbor_bottom = attacher_box_display_bg.get_path_to(confirm_btn_bg)


func refresh_blood_type_view() -> void:
	_reset_focus(blood_type_view_bg)

	var loaded_cell: BrainCell = parent_attacher._get_loaded_cell()

	# no cell
	if not loaded_cell:
		blood_type_view_bg.focus_mode = Control.FOCUS_NONE
		return

	# cell loaded
	blood_type_view_bg.focus_mode = Control.FOCUS_ALL

	var up_target: Control = get_main_stat_focus_target._get_target("community")
	var left_target: Control = blood_type_view_bg

	# left : last jar item or itself
	var last_jar_item: Control = get_ordered_jar_item._get_ordered("last")

	if last_jar_item:
		left_target = last_jar_item.bg

	blood_type_view_bg.focus_neighbor_top = blood_type_view_bg.get_path_to(up_target)
	blood_type_view_bg.focus_neighbor_left = blood_type_view_bg.get_path_to(left_target)
	blood_type_view_bg.focus_neighbor_right = blood_type_view_bg.get_path_to(attacher_box_display_bg)


func refresh_failure_chance_view() -> void:
	_reset_focus(failure_chance_view_detect_rect)

	var loaded_cell: BrainCell = parent_attacher._get_loaded_cell()

	# no cell
	if not loaded_cell:
		failure_chance_view_detect_rect.focus_mode = Control.FOCUS_NONE
		return

	# cell loaded
	failure_chance_view_detect_rect.focus_mode = Control.FOCUS_ALL

	var up_target: Control = get_main_stat_focus_target._get_target("community")

	failure_chance_view_detect_rect.focus_neighbor_top = failure_chance_view_detect_rect.get_path_to(up_target)
	failure_chance_view_detect_rect.focus_neighbor_left = failure_chance_view_detect_rect.get_path_to(attacher_box_display_bg)


func refresh_main_stats() -> void:
	var loaded_cell: BrainCell = parent_attacher._get_loaded_cell()

	# no cell : disable all main stat focus
	if not loaded_cell:
		for control in [
			strength_default_detect_rect,
			strength_replacement_failure_rate_bg,
			strength_replacement_remove_btn_bg,

			intelligence_default_detect_rect,
			intelligence_replacement_failure_rate_bg,
			intelligence_replacement_remove_btn_bg,

			community_default_detect_rect,
			community_replacement_failure_rate_bg,
			community_replacement_remove_btn_bg
		]:
			_reset_focus(control)
			control.focus_mode = Control.FOCUS_NONE

		return

	# get correct default / replacement targets
	var strength_target: Control = get_main_stat_focus_target._get_target("strength")
	var intelligence_target: Control = get_main_stat_focus_target._get_target("intelligence")
	var community_target: Control = get_main_stat_focus_target._get_target("community")

	# left target for all main stats
	var first_jar_bg: Control = null
	var first_jar_item: Control = get_ordered_jar_item._get_ordered("first")

	if first_jar_item:
		first_jar_bg = first_jar_item.bg

	# strength
	refresh_main_stat(
		strength_default_detect_rect,
		strength_replacement_failure_rate_bg,
		strength_replacement_remove_btn_bg,
		exit_btn_bg,
		intelligence_target,
		first_jar_bg
	)

	# intelligence
	refresh_main_stat(
		intelligence_default_detect_rect,
		intelligence_replacement_failure_rate_bg,
		intelligence_replacement_remove_btn_bg,
		strength_target,
		community_target,
		first_jar_bg
	)

	# community
	refresh_main_stat(
		community_default_detect_rect,
		community_replacement_failure_rate_bg,
		community_replacement_remove_btn_bg,
		intelligence_target,
		attacher_box_display_bg,
		first_jar_bg
	)


func refresh_main_stat(
	default_bg: ColorRect,
	failure_rate_bg: ColorRect,
	remove_btn_bg: TextureRect,
	up_target: Control,
	down_target: Control,
	first_jar_bg: Control
) -> void:

	_reset_focus(default_bg)
	_reset_focus(failure_rate_bg)
	_reset_focus(remove_btn_bg)

	var main_stat: Control = default_bg.get_parent()

	# check replacement
	var has_replacement: bool = main_stat.replacement_stat_jar_item != null

	# check failure penalty
	var failure_penalty_enabled: bool = (
		has_replacement
		and parent_attacher.failure_rate_enabled
		and main_stat.penality_failure_rate_parent.visible
	)

	# set focus availability
	default_bg.focus_mode = (
		Control.FOCUS_NONE if has_replacement
		else Control.FOCUS_ALL
	)

	remove_btn_bg.focus_mode = (
		Control.FOCUS_ALL if has_replacement
		else Control.FOCUS_NONE
	)

	failure_rate_bg.focus_mode = (
		Control.FOCUS_ALL if failure_penalty_enabled
		else Control.FOCUS_NONE
	)


	## default detect rect

	var default_left_target: Control = default_bg

	# left : first jar item or itself
	if first_jar_bg:
		default_left_target = first_jar_bg

	default_bg.focus_neighbor_top = default_bg.get_path_to(up_target)
	default_bg.focus_neighbor_bottom = default_bg.get_path_to(down_target)
	default_bg.focus_neighbor_left = default_bg.get_path_to(default_left_target)


	## replacement failure rate

	var failure_left_target: Control = failure_rate_bg

	# left : first jar item or itself
	if first_jar_bg:
		failure_left_target = first_jar_bg

	failure_rate_bg.focus_neighbor_top = failure_rate_bg.get_path_to(up_target)
	failure_rate_bg.focus_neighbor_bottom = failure_rate_bg.get_path_to(down_target)
	failure_rate_bg.focus_neighbor_left = failure_rate_bg.get_path_to(failure_left_target)
	failure_rate_bg.focus_neighbor_right = failure_rate_bg.get_path_to(remove_btn_bg)


	## replacement remove btn

	var remove_left_target: Control = remove_btn_bg

	# left : failure penalty if enabled
	if failure_penalty_enabled:
		remove_left_target = failure_rate_bg

	# otherwise : first jar item or itself
	elif first_jar_bg:
		remove_left_target = first_jar_bg

	remove_btn_bg.focus_neighbor_top = remove_btn_bg.get_path_to(up_target)
	remove_btn_bg.focus_neighbor_bottom = remove_btn_bg.get_path_to(down_target)
	remove_btn_bg.focus_neighbor_left = remove_btn_bg.get_path_to(remove_left_target)


## util helpers

func _reset_focus(control: Control) -> void:
	var self_path: NodePath = control.get_path_to(control)

	# block all directions by default
	control.focus_neighbor_top = self_path
	control.focus_neighbor_bottom = self_path
	control.focus_neighbor_left = self_path
	control.focus_neighbor_right = self_path

	# always prevent next / previous navigation
	control.focus_next = self_path
	control.focus_previous = self_path
