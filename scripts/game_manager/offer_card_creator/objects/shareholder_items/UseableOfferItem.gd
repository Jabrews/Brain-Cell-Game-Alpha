extends Node

class_name UseableOfferItem 

var item_type: String
var flavor_text : String


func _init(
	new_item_type : String,
	new_flavor_text : String
):
	item_type = new_item_type
	flavor_text = new_flavor_text
