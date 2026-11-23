extends Node

# creation methods
@onready var default_prisoner_create: Node = $CreationMethods/DefaultPrisonerCreate


func _generate_prisoner_cells(
	_ideal_stats: Array[IdealStat],
	prisoner_card: PrisonerOfferCard
) -> Array[BrainCell]:
	var alteration: String = prisoner_card.alteration

	match alteration:
		"":
			pass
		"exsplosive":
			# TODO: Add explosive-specific creation. return early
			pass
		_:
			push_error("Unknown prisoner alteration: " + alteration)
			return []

	var quantity: int = prisoner_card.prisoner_quanity
	if quantity < 0:
		push_error("Prisoner quantity cannot be negative.")
		return []

	var prisoner_cells: Array[BrainCell] = []

	for _index in range(quantity):
		prisoner_cells.append(default_prisoner_create._create(prisoner_card))

	return prisoner_cells
