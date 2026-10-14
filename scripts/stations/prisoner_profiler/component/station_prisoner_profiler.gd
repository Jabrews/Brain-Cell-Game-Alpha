extends Node

# compoents
@onready var toggle_ideal_stat_creator_enabled : Node = $Logic/IdealStatCreator/ToggleEnabled
@onready var toggle_offer_tablet_enabled : Node = $Logic/OfferTablet/ToggleEnabled

# ideal stat creator finalized stats
var strength_ideal_stat : IdealStat = null
var intelligence_ideal_stat : IdealStat = null
var community_ideal_stat : IdealStat = null


func _ready() -> void:
	
	await get_tree().process_frame
	
	toggle_ideal_stat_creator_enabled._toggle(true)


func handle_ideal_stats_finished(
	new_str_ideal_stat : IdealStat,
	new_int_ideal_stat : IdealStat,
	new_com_ideal_stat : IdealStat,
	
) :
	
	strength_ideal_stat = new_str_ideal_stat
	intelligence_ideal_stat = new_int_ideal_stat
	community_ideal_stat = new_com_ideal_stat
	
	toggle_ideal_stat_creator_enabled._toggle(false)
	
	toggle_offer_tablet_enabled._toggle(true)
	
	
	
