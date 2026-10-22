# OfferPickedCinnamatic.gd
extends Node

@onready var turn_cinnamatic: Node = $TurnCinnamatic
@onready var prisoner_cinnamatic: Node = $PrisonerCinnamatic
@onready var shareholder_item_cinnamatic: Node = $ShareholderItemCinnamatic


func _initate(offer_card: OfferCard) -> void:
	toggle_display_lock(true)
	GLCinnamaticBus.emit_signal("toggle_offer_picked_cinnamatic", true)

	var finished: bool = await turn_cinnamatic._initate()
	if not finished:
		_finish()
		return

	match offer_card.card_type:
		"prisoner":
			finished = await prisoner_cinnamatic._initate(offer_card)
		"shareholder_items":
			finished = await shareholder_item_cinnamatic._initate(offer_card)
		_:
			push_warning("Unknown offer card type: " + offer_card.card_type)
			finished = false

	if finished:
		_finish()


func _finish() -> void:
	toggle_display_lock(false)
	GLCinnamaticBus.emit_signal("toggle_offer_picked_cinnamatic", false)


func toggle_display_lock(toggle_value: bool) -> void:
	GLHideUiBus.emit_signal("toggle_hide_ui", toggle_value)
	GLPlayerState.emit_signal("toggle_freeze_player", toggle_value)
	Input.mouse_mode = (
		Input.MOUSE_MODE_HIDDEN if toggle_value
		else Input.MOUSE_MODE_CAPTURED
	)
