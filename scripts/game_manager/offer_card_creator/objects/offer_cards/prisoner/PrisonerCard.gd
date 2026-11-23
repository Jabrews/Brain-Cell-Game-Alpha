extends OfferCard
class_name PrisonerOfferCard


var strength: PrisonerCardStat
var intelligence: PrisonerCardStat
var community: PrisonerCardStat

var total_defect_rate: int
var prisoner_picks: int
var prisoner_quanity : int
var average_lifespan: int
var alteration : String
var prisoner_cells: Array[BrainCell]


func _init(
	new_strength: PrisonerCardStat,
	new_intelligence: PrisonerCardStat,
	new_community: PrisonerCardStat,
	
	new_total_defect_rate: int = 1,
	new_prisoner_picks: int = 1,
	new_prisoner_quanity : int = 1,
	new_average_lifespan: int = 0,
	new_alteration : String = "",
	new_prisoner_cells: Array[BrainCell] = []
) -> void:
	
	super("prisoner", "A standard prisoner card")

	strength = new_strength
	intelligence = new_intelligence
	community = new_community
	
	total_defect_rate = new_total_defect_rate
	prisoner_picks = new_prisoner_picks
	prisoner_quanity = new_prisoner_quanity
	average_lifespan = new_average_lifespan
	alteration = new_alteration
	prisoner_cells = new_prisoner_cells.duplicate()


func print_card() -> void:
	super.print_card()

	print("Strength: ", strength.min_value, "–", strength.max_value)
	print("Intelligence: ", intelligence.min_value, "–", intelligence.max_value)
	print("Community: ", community.min_value, "–", community.max_value)
	print("Total Defect rate: ", total_defect_rate)
	print("Prisoner picks: ", prisoner_picks)
	print("Prisoner quanity: ", prisoner_quanity)
	print("Average lifespan: ", average_lifespan)
	print("Alteration : ", alteration)
	print("Prisoner cells: ", prisoner_cells.size())
