extends Node

# debug
var display_stat_offer_active_debug_messages : bool = true 

# lets shareholder offers toggle manager know to turn off all prior offers when new round
signal next_round_stat_offers()

# tells cell_prisoner_cretor to await offer card being chose
var await_user_choose_shareholder_offer_before_create : bool = false
signal create_prisoner_cells_user_chose_shareholder_offer()

# stat offer signals (very few need this, most use toggle state)



##### item offer #####
var items_to_offer = ['defect_shot', 'hidden_shot', 'steroid']
######################

var round_1_stat_offers : Array[StatOfferItem] = [
	StatOfferItem.new(
		'effects_prisoners', 1, 'Only 3 possible prisoners can be picked throughout the round (random), but all their clean stats are increased by 20%.'
	),
	StatOfferItem.new(
		'effects_breeding', 2, 'All breeding results give max postive returns. However, defect stat get another additional 10% value from breeding'
	)
]
var round_2_stat_offers : Array[StatOfferItem] = [
	StatOfferItem.new(
		'effects_defect', 3, 'ALl generated cells in the following turn have no defect. BUT one is chosen to transform into a flesh slug '
	),
	StatOfferItem.new(
		'effects_defect', 4, 'Reduce defect event chance by 15%, but increase defect on new cells by 10%.'
	)
]
var round_3_stat_offers : Array[StatOfferItem] = [
	StatOfferItem.new(
		'effects_prisoners', 5, 'Greatly reduces amount of hidden stats. BUT remaining hidden stats are more likely to hide high infection.'
	),
	StatOfferItem.new(
		'effects_defect', 6, 'Increase chance of ALL hidden stat interpreter jolting by 15%, BUT reduce overall defect event chance by 10%.'
	)
]
var round_4_stat_offers : Array[StatOfferItem] = [
	StatOfferItem.new(
		'effects_defect', 7, 'Reduce defect event chance by 10%, but jolted cells now increase defect much more aggressively'
	),
	StatOfferItem.new(
		'effects_prisoners', 8, 'All collected cells lifespan become 1 turn, but newly generated defect decrease by 10%.'
	)
]

##### stat offer #####
## round 1 ##
var offer_1_active : bool = false
var offer_2_active : bool = false
## round 2 ##
var offer_3_active : bool = false
var offer_4_active : bool = false
## round 3 ##
var offer_5_active : bool = false
var offer_6_active : bool = false
## round 4 ##
var offer_7_active : bool = false
var offer_8_active : bool = false
#######################
