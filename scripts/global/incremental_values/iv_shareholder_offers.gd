extends Node

var item_offer_energy_percant : int = 0
var first_round_item_offer_energy_percant : int = 0

# offer demand generator
var energy_reward_min = 25
var energy_reward_max = 30
var energy_left_to_claim_min = 30
var energy_left_to_claim_max = 35
var non_enabled_stats_max = 0

# generate cell offer
var can_generate_cell_offer : bool = false
var chance_of_generating_cell_offer : int = 100


# generate mutation offer
var can_generate_mutation_offer : bool = false
var chance_of_generating_mution_offer : int = 0
