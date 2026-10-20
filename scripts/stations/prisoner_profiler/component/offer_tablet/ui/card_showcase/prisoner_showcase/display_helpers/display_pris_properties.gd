extends Node

@onready var lifespan_label : Label = $"../../PropertyInfo/AverageLifespan/AverageLifspanLabel"

func _display(prisoner_card : PrisonerOfferCard) : 
	
	lifespan_label.text = str(prisoner_card.average_lifespan)
