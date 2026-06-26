extends Node

@onready var large_stat_screen_defect_background : Array[ColorRect] = [
	$"../../../../../StatDisplay/StatPanels/StrengthStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/SpareSymbols/Defect/DefectBG",
	$"../../../../../StatDisplay/StatPanels/IntelligenceStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/SpareSymbols/Defect/DefectBG",
	$"../../../../../StatDisplay/StatPanels/CommunityStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/SpareSymbols/Defect/DefectBG",
]
@onready var small_stat_screens_defect_background : ColorRect = $"../../../../../ControlInterface/SmallStatDisplay/TvFrontPanel/SubViewport/SmallStatDisplay/StatDisplay/SpareSymbols/Defect/DefectBG"
