extends Node

@onready var large_stat_screen_bad_mutation_background : Array[ColorRect] = [
	$"../../../../../StatDisplay/StatPanels/StrengthStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/SpareSymbols/BadMutation/MutationBG",
	$"../../../../../StatDisplay/StatPanels/IntelligenceStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/SpareSymbols/BadMutation/MutationBG",
	$"../../../../../StatDisplay/StatPanels/CommunityStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/SpareSymbols/BadMutation/MutationBG",
]
@onready var small_stat_screens_bad_mutation_background : ColorRect = $"../../../../../ControlInterface/SmallStatDisplay/TvFrontPanel/SubViewport/SmallStatDisplay/StatDisplay/SpareSymbols/BadMutation/MutationBG"
