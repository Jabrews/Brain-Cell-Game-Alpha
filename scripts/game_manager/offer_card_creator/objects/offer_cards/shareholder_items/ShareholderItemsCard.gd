extends OfferCard
class_name ShareholderItemsCard


var items: Array[UseableOfferItem] = []


func _init(
	new_items: Array[UseableOfferItem] = []
) -> void:
	
	super("shareholder_items", "Given 3 choices of items and player must choose one")
			
	
	
	items = new_items.duplicate()


func print_card() -> void:
	super.print_card()
	print("Items: ", items.size())

	for item in items:
		print(" - ", item)
