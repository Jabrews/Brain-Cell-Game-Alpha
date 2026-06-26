extends Node

@onready var large_stat_screen_energy_background : Array[ColorRect] = [
	$"../../../../../StatDisplay/StatPanels/StrengthStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/SpareSymbols/Energy/EnergyBG",
	$"../../../../../StatDisplay/StatPanels/IntelligenceStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/SpareSymbols/Energy/EnergyBG",
	$"../../../../../StatDisplay/StatPanels/CommunityStatPanel/CapControlTv/SubViewport/LargeStatDisplay/StatDisplay/SpareSymbols/Energy/EnergyBG",
]
@onready var small_stat_screens_energy_background : ColorRect = $"../../../../../ControlInterface/SmallStatDisplay/TvFrontPanel/SubViewport/SmallStatDisplay/StatDisplay/SpareSymbols/Energy/EnergyBG"
