extends Node

@onready var none_parent : Control = $"../../Alterations/None"
@onready var exsplosive_parent : Control = $"../../Alterations/Exsplosive"

func _display(prisoner_card : PrisonerOfferCard) : 
	
	if prisoner_card.alteration == '' : 
		none_parent.visible = true
	
	else : 
		match prisoner_card.alteration : 
			'exsplosive' : 
				exsplosive_parent.visible = true
		
	
