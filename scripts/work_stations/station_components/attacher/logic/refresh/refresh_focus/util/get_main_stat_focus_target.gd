extends Node

# str
@onready var strength_main_stat: Control = $"../../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Strength"
@onready var strength_default_detect_rect: ColorRect = $"../../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Strength/DefaultDetectRect"
@onready var strength_replacement_remove_btn_bg: TextureRect = $"../../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Strength/StatReplacement/ReplacementInfoContainer/Header/RemoveBtn/BtnBG"

# int
@onready var intelligence_main_stat: Control = $"../../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Intelligence"
@onready var intelligence_default_detect_rect: ColorRect = $"../../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Intelligence/DefaultDetectRect"
@onready var intelligence_replacement_remove_btn_bg: TextureRect = $"../../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Intelligence/StatReplacement/ReplacementInfoContainer/Header/RemoveBtn/BtnBG"

# com
@onready var community_main_stat: Control = $"../../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Community"
@onready var community_default_detect_rect: ColorRect = $"../../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Community/DefaultDetectRect"
@onready var community_replacement_remove_btn_bg: TextureRect = $"../../../../AttacherUI/Content/StatMainView/Stats/StatsVBox/Community/StatReplacement/ReplacementInfoContainer/Header/RemoveBtn/BtnBG"


func _get_target(stat_type: String) -> Control:

	var main_stat: Control
	var default_detect_rect: ColorRect
	var remove_btn_bg: TextureRect

	match stat_type:
		"strength":
			main_stat = strength_main_stat
			default_detect_rect = strength_default_detect_rect
			remove_btn_bg = strength_replacement_remove_btn_bg

		"intelligence":
			main_stat = intelligence_main_stat
			default_detect_rect = intelligence_default_detect_rect
			remove_btn_bg = intelligence_replacement_remove_btn_bg

		"community":
			main_stat = community_main_stat
			default_detect_rect = community_default_detect_rect
			remove_btn_bg = community_replacement_remove_btn_bg

	if not main_stat:
		push_error("Unable to find main stat of type: ", stat_type)
		return null

	# replacement
	if main_stat.replacement_stat_jar_item:
		return remove_btn_bg

	# default
	return default_detect_rect
