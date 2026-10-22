extends Node

# compoentns
@onready var alteration_label : Label = $AlterationLabel
@onready var off_rect : ColorRect = $OffRect

func _update(prisoner_offer_card : PrisonerOfferCard) :
	
	var alteration_text : String
	
	match prisoner_offer_card.alteration : 	
		'exsplosive' : 
			alteration_text = 'Exsplosive Alteration Found'
	
	if alteration_text : 
		off_rect.visible = false 
		alteration_label.text = alteration_text		
		
	else : 
		off_rect.visible = true
		alteration_label.text = ''
	

func _turn_off() :
	off_rect.visible = true
	alteration_label.text = ''
