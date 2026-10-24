extends Control

# compoents
@onready var handle_start : Node = $HandleStart
@onready var handle_stop : Node = $HandleStop
@onready var toggle_focus : Node = $ToggleFocus

# display helpers
@onready var display_defect_info : Node = $DisplayHelpers/DisplayDefectInfo
@onready var display_pris_picks : Node = $DisplayHelpers/DisplayPrisPicks
@onready var display_pris_properties : Node = $DisplayHelpers/DisplayPrisProperties
@onready var display_alterations : Node = $DisplayHelpers/DisplayAlteration


var loaded_prisoner_card : PrisonerOfferCard

func _load_offer(prisoner_card : PrisonerOfferCard) :
	loaded_prisoner_card = prisoner_card
	
	# display helpers
	display_defect_info._display(loaded_prisoner_card)
	display_pris_picks._display(loaded_prisoner_card)
	display_pris_properties._display(loaded_prisoner_card)
	display_alterations._display(loaded_prisoner_card)
	
func _start() :
	
	if not loaded_prisoner_card : 
		return
	
	handle_start._handle(loaded_prisoner_card)
	
	toggle_focus._toggle(true)

func _stop() : 
	
	handle_stop._handle()
	
	toggle_focus._toggle(false)
