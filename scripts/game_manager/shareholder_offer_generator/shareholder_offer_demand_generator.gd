extends Node


# offer generate helpers
@onready var generate_cell_offer : Node = $GenerateCellOffer
@onready var generate_mutation_offer : Node = $GenerateMutationOffer


func _ready() -> void:
	GLShareholderOfferState .connect('create_item_offer_demand', _create_demand)
	
	# for canceling targeted mutation prisoner creation
	GLShareholderOfferState.connect('item_offer_ended', _handle_item_offer_ended)
	
	
func _create_demand() -> void:
	var energy_reward: int = randi_range(
		IVShareholderOffers.energy_reward_min,
		IVShareholderOffers.energy_reward_max
	)

	var energy_left_to_claim: int = randi_range(
		IVShareholderOffers.energy_left_to_claim_min,
		IVShareholderOffers.energy_left_to_claim_max
	)

	var can_generate_cell_offer: bool = (
		IVShareholderOffers.can_generate_cell_offer
	)

	var can_generate_mutation_offer: bool = (
		IVShareholderOffers.can_generate_mutation_offer
	)

	var demand_type: String = ""

	# Neither offer type is available.
	if not can_generate_cell_offer and not can_generate_mutation_offer:
		return

	# Only cell offers are available.
	if can_generate_cell_offer and not can_generate_mutation_offer:
		demand_type = "cell"

	# Only mutation offers are available.
	elif can_generate_mutation_offer and not can_generate_cell_offer:
		demand_type = "mutation"

	# Both are available.
	else:
		var chance_to_generate_cell: int = (
			IVShareholderOffers.chance_of_generating_cell_offer
		)

		var chance_num: int = randi_range(1, 100)

		if chance_num <= chance_to_generate_cell:
			demand_type = "cell"
		else:
			demand_type = "mutation"

	var item_offer_constructor: ItemOfferDemandConstructor

	match demand_type:
		"cell":
			var demand_cell: BrainCell = (
				generate_cell_offer._generate_demand_cell()
			)

			item_offer_constructor = ItemOfferDemandConstructor.new(
				"cell",
				energy_reward,
				energy_left_to_claim,
				demand_cell,
			)

		"mutation":
			var demand_mutation: BrainCellMutation = (
				generate_mutation_offer._generate_demand_mutation()
			)

			item_offer_constructor = ItemOfferDemandConstructor.new(
				"mutation",
				energy_reward,
				energy_left_to_claim,
				null,
				demand_mutation,
			)
			
			IVCellCreator.shareholder_demand_cell_mutation = demand_mutation

		_:
			push_error("Invalid shareholder demand type: " + demand_type)
			return

	GLShareholderOfferState.emit_signal(
		"recieve_item_offer_demand",
		item_offer_constructor
	)

func _handle_item_offer_ended() :
	IVCellCreator.shareholder_demand_cell_mutation = null
	
