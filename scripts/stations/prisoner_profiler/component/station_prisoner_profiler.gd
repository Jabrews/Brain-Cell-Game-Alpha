extends Node

# compoents
@onready var toggle_ideal_stat_creator_enabled : Node = $Logic/IdealStatCreator/ToggleEnabled
@onready var toggle_offer_tablet_enabled : Node = $Logic/OfferTablet/ToggleEnabled
@onready var offer_picked_cinnamatic : Node = $Logic/OfferPickedCinnamatic

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

func handle_offer_picked(offer_card : OfferCard): 
	
	strength_ideal_stat = null
	intelligence_ideal_stat = null
	community_ideal_stat = null
	
	toggle_offer_tablet_enabled._toggle(false)
	
	toggle_ideal_stat_creator_enabled._toggle(true)
	
	offer_picked_cinnamatic._initate(offer_card)
	

func get_finalized_ideal_stats() -> Array[IdealStat] :
	return [strength_ideal_stat, intelligence_ideal_stat, community_ideal_stat]
	
	
