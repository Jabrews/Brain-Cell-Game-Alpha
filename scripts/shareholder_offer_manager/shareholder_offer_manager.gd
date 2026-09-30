extends Node

# components
@onready var serve_item_offer_parent: Control = $ServeItemOffer
@onready var header_label: Label = $HeaderLabel
@onready var blur_bg: ColorRect = $BlurBg

# sounds
@onready var s_start: AudioStreamPlayer2D = $ServeItemOffer/Audio/Start
@onready var s_select: AudioStreamPlayer2D = $ServeItemOffer/Audio/Select

# cards
@onready var item_offer_card_1: TextureRect = $ServeItemOffer/Card1Container
@onready var item_offer_card_2: TextureRect = $ServeItemOffer/Card2Container
@onready var item_offer_card_3: TextureRect = $ServeItemOffer/Card3Container


func _ready() -> void:
	toggle_display_lock(false)
	toggle_mouse_filter(false)


func serve_item_cards() -> void:
	toggle_display_lock(true)
	toggle_mouse_filter(true)

	serve_item_offer_parent.visible = true
	s_start.play()

	var item_to_offer_copy = GLShareholderOfferState.items_to_offer.duplicate()

	# get random item for card 1
	var item_1 = item_to_offer_copy.pick_random()
	item_to_offer_copy.erase(item_1)

	# get random item for card 2
	var item_2 = item_to_offer_copy.pick_random()
	item_to_offer_copy.erase(item_2)

	# get random item for card 3
	var item_3 = item_to_offer_copy.pick_random()
	item_to_offer_copy.erase(item_3)

	# set cards
	item_offer_card_1.update(item_1)
	item_offer_card_2.update(item_2)
	item_offer_card_3.update(item_3)

	if GAMEInputTypeDetector.input_type == "controller":
		item_offer_card_1.grab_focus()

	GLPlayerState.emit_signal("lock_player_position", true)


func handle_card_picked(offer_card: TextureRect) -> void:
	s_select.play()

	var tween := create_tween()

	tween.set_pause_mode(
		Tween.TWEEN_PAUSE_PROCESS
	)

	# move card downward off screen
	tween.tween_property(
		offer_card,
		"position:y",
		offer_card.position.y + 300,
		0.8
	).set_trans(
		Tween.TRANS_BACK
	).set_ease(
		Tween.EASE_IN
	)

	# fade out
	tween.parallel().tween_property(
		offer_card,
		"modulate:a",
		0.0,
		0.8
	)

	await tween.finished

	serve_item_offer_parent.visible = false

	var item_offer: UseableOfferItem = (
		offer_card.designated_useable_item_offer
	)

	GLShareholderOfferState.emit_signal(
		"spawn_item_to_offer",
		item_offer
	)

	toggle_display_lock(false)
	toggle_mouse_filter(false)

	GLPlayerState.emit_signal(
		"lock_player_position",
		false
	)


func toggle_display_lock(toggle_value: bool) -> void:
	if toggle_value:
		header_label.visible = true
		blur_bg.visible = true

		GLHideUiBus.emit_signal(
			"toggle_hide_ui",
			true
		)

		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true

	else:
		header_label.visible = false
		blur_bg.visible = false

		GLHideUiBus.emit_signal(
			"toggle_hide_ui",
			false
		)

		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false


func toggle_mouse_filter(toggle_value: bool) -> void:
	if toggle_value:
		serve_item_offer_parent.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		serve_item_offer_parent.mouse_filter = Control.MOUSE_FILTER_IGNORE
