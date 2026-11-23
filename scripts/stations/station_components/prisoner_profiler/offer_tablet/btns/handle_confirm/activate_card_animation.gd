
extends Node

const card_finale_pos: Vector2 = Vector2(512.0, -352.0)
const card_first_pos: Vector2 = Vector2(512.0, 136.0)

const first_pos_time: float = 0.2
const finale_pos_time: float = 0.8
const unselected_card_fade_time: float = 0.5


func _activate(sorted_preview_cards: Dictionary) -> bool:
	var confirmed_card: Control = sorted_preview_cards.get("confirmed")
	var unselected_cards: Array = sorted_preview_cards.get("unselected", [])
	
	if confirmed_card == null:
		push_error("No confirmed card in sorted_preview_cards.")
		return false

	# Move the confirmed card to the first position.
	var first_tween := create_tween()
	first_tween.tween_property(
		confirmed_card, "position", card_first_pos, first_pos_time
	)
	await first_tween.finished
	

	# Fade out all unselected cards at the same time.
	var cards_to_hide: Array[Control] = []
	var fade_tween := create_tween()
	fade_tween.set_parallel(true)

	for card in unselected_cards:
		if card is Control:
			cards_to_hide.append(card)
			fade_tween.tween_property(
				card, "modulate:a", 0.0, unselected_card_fade_time
			)

	if not cards_to_hide.is_empty():
		await fade_tween.finished

		for card: Control in cards_to_hide:
			card.hide()

	# Move the confirmed card to its final position.
	var finale_tween := create_tween()
	finale_tween.tween_property(
		confirmed_card, "position", card_finale_pos, finale_pos_time
	)
	await finale_tween.finished

	return true
