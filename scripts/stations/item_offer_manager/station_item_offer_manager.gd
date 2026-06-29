extends Node

@onready var screen_demand_display : Node2D = $Displays/DemandDisplay/SubViewport/ItemOfferDemand
@onready var screen_energy_left_to_claim : Node2D = $Displays/EnergyLeftToClaimDisplay/SubViewport/EnergyLeftToClaimDisplay
@onready var screen_reward_energy  : Node2D = $Displays/RewardEnergyDisplay/SubViewport/ScreenEnergyReward


func _ready() -> void:
	GLShareholderOfferState.connect('recieve_item_offer_demand', _handle_recieve_item_offer_demand)


func _handle_recieve_item_offer_demand(offer_demand_constructor : ItemOfferDemandConstructor) :
	
	toggle_switch_active_offer(true)
	
	if offer_demand_constructor.demand_type == 'cell' :
		pass
		#screen_demand_display._load_demand_ell(offer_demand_constructor.demand_cell)
		
	#screen_energy_left_to_claim._load_inital_energy_left(offer_demand_constructor.energy_left_to_claim)
	#screen_reward_energy._load_reward(offer_demand_constructor.energy_reward)


func toggle_switch_active_offer(toggle_value : bool) :
	screen_demand_display.switch_screen._toggle_active_offer(toggle_value)
	screen_energy_left_to_claim.switch_screen._toggle_active_offer(toggle_value)
	screen_reward_energy.switch_screen._toggle_active_offer(toggle_value)
	
	
