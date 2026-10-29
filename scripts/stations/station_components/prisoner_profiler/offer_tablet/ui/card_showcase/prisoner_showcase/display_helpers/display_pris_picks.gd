extends Node

@onready var prisoner_sprites: Array[Sprite2D] = [
	$"../../PrisPicks/PrisonerSprites/Prisoner1",
	$"../../PrisPicks/PrisonerSprites/Prisoner2",
	$"../../PrisPicks/PrisonerSprites/Prisoner3",
	$"../../PrisPicks/PrisonerSprites/Prisoner4"
]

@onready var pick_symbol_sprites: Array[Sprite2D] = [
	$"../../PrisPicks/PickSymbolSprites/PickSymbol1",
	$"../../PrisPicks/PickSymbolSprites/PickSymbol2",
	$"../../PrisPicks/PickSymbolSprites/PickSymbol3",
	$"../../PrisPicks/PickSymbolSprites/PickSymbol4"
]

@onready var in_batch_label: Label = $"../../PrisPicks/PicksLabels/InBatchLabel"
@onready var pick_label: Label = $"../../PrisPicks/PicksLabels/PicksLabel"


func _display(prisoner_card: PrisonerOfferCard) -> void:
	if prisoner_card == null:
		push_error("Cannot display a null prisoner card.")
		return

	var batch_count: int = prisoner_card.prisoner_quanity
	var pick_count: int = prisoner_card.prisoner_picks

	in_batch_label.text = "Prisoners In Batch: %d" % batch_count
	pick_label.text = "Available to Pick: %d" % pick_count

	for i in range(prisoner_sprites.size()):
		prisoner_sprites[i].visible = i < batch_count

	for i in range(pick_symbol_sprites.size()):
		pick_symbol_sprites[i].visible = i < pick_count
