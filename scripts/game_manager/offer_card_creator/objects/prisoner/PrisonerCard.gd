extends OfferCard

class_name PrisonerOfferCard

var strength: PrisonerCardStat = PrisonerCardStat.new()
var intelligence: PrisonerCardStat = PrisonerCardStat.new()
var community: PrisonerCardStat = PrisonerCardStat.new()

var defect_rate: int = 1 # Range: 1–100
var prisoner_picks: int = 1
var average_lifespan: int = 0
var specialization: String = ""

var prisoner_cells: Array[BrainCell] = []

func print_card() -> void:
	super.print_card()

	print("Strength: ", strength.min_value, "–", strength.max_value)
	print("Intelligence: ", intelligence.min_value, "–", intelligence.max_value)
	print("Community: ", community.min_value, "–", community.max_value)
	print("Defect rate: ", defect_rate)
	print("Prisoner picks: ", prisoner_picks)
	print("Average lifespan: ", average_lifespan)
	print("Specialization: ", specialization)
	print("Prisoner cells: ", prisoner_cells.size())
