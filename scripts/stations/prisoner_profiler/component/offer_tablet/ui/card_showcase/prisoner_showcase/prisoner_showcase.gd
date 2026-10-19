extends Control

# compoents
@onready var handle_start : Node = $HandleStart
@onready var handle_stop : Node = $HandleStop

# display helpers
@onready var display_defect_info : Node = $DisplayHelpers/DisplayDefectInfo
@onready var display_pris_picks : Node = $DisplayHelpers/DisplayPrisPicks


var loaded_prisoner_card : PrisonerOfferCard

func _load_offer(prisoner_card : PrisonerOfferCard) :
	loaded_prisoner_card = prisoner_card
	
	# display helpers
	display_defect_info._display(loaded_prisoner_card)
	display_pris_picks._display(loaded_prisoner_card)
	
func _start() :
	
	if not loaded_prisoner_card : 
		return
	
	handle_start._handle(loaded_prisoner_card)

func _stop() : 
	
	handle_stop._handle()
