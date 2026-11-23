extends RefCounted

class_name OfferCard

var card_type: String
var card_description: String


func _init(
	new_card_type: String = "",
	new_card_description: String = ""
) -> void:
	card_type = new_card_type
	card_description = new_card_description


func print_card() -> void:
	print("Type: ", card_type, " | Description: ", card_description)
