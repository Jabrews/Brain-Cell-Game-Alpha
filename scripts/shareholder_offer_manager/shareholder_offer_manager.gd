extends Node

# components

@onready var serve_item_offer_parent: Control = $ServeItemOffer
@onready var header_label: Label = $HeaderLabel
@onready var blur_bg: ColorRect = $BlurBg

# cards

@onready var item_offer_card_1: TextureRect = $ServeItemOffer/Card1Container
@onready var item_offer_card_2: TextureRect = $ServeItemOffer/Card2Container
@onready var item_offer_card_3 : TextureRect = $ServeItemOffer/Card3Container


var serve_first_card_next_turn: bool = false
var serve_second_card_next_turn: bool = false

var has_served_first_card: bool = false
var has_served_second_card: bool = false


func _ready() -> void:
	GLGameManagerBus.connect(
		"proceed_next_round",
		_handle_next_round
	)

	GLGameManagerBus.connect(
		"proceed_next_energy_turn",
		_handle_energy_turn_changed
	)

	GLGameManagerBus.connect(
		"energy_changed",
		_handle_energy_changed
	)

	toggle_display_lock(false)
	toggle_mouse_filter(false)


func _handle_energy_changed() -> void:
	# energy changes can schedule an offer.
	# they never serve it.
	_check_if_offer_should_be_scheduled()


func _handle_energy_turn_changed() -> void:
	# serve something that was scheduled BEFORE this turn.
	if serve_first_card_next_turn:
		serve_first_card_next_turn = false
		has_served_first_card = true
		GLEventNoticeManagerBus.emit_signal('delete_event_notice_shareholder_item_offer', 1)
		GLEventNoticeManagerBus.emit_signal('toggle_hide_event_notice', false)

		
		serve_item_cards()
		return

	if serve_second_card_next_turn:
		serve_second_card_next_turn = false
		has_served_second_card = true
		GLEventNoticeManagerBus.emit_signal('delete_event_notice_shareholder_item_offer', 1)
		GLEventNoticeManagerBus.emit_signal('toggle_hide_event_notice', false)
		

		serve_item_cards()
		return

	# Nothing was waiting to be served.
	# Now check if this turn should schedule something
	# for the NEXT energy turn.
	_check_if_offer_should_be_scheduled()


func _check_if_offer_should_be_scheduled() -> void:
	var curr_energy: int = GLGameManagerBus.curr_energy
	var max_energy: int = GLGameManagerBus.max_energy

	var energy_percent: float = (
		curr_energy / float(max_energy)
	) * 100.0


	# FIRST OFFER
	if (
		energy_percent <= IVShareholderOffers.first_item_offer_energy_percant
		and not has_served_first_card
		and not serve_first_card_next_turn
	):
		serve_first_card_next_turn = true
		
		GLEventNoticeManagerBus.emit_signal(
			"create_event_notice",
			EventNotice.new(
				"default",
				"Item offer incoming next turn.",
				{'serve_num' : 1}
			)
		)
		


		return


	# Don't schedule second while first is still waiting.
	if serve_first_card_next_turn:
		return


	# SECOND OFFER
	if (
		energy_percent <= IVShareholderOffers.second_item_offer_energy_percant
		and not has_served_second_card
		and not serve_second_card_next_turn
	):
		serve_second_card_next_turn = true
		
		GLEventNoticeManagerBus.emit_signal(
			"create_event_notice",
			EventNotice.new(
				"default",
				"Item offer incoming next turn.",
				{'serve_num' : 2}
			)
		)
		


func _handle_next_round() -> void:
	serve_first_card_next_turn = false
	serve_second_card_next_turn = false

	has_served_first_card = false
	has_served_second_card = false


func serve_item_cards() -> void:
	toggle_display_lock(true)
	toggle_mouse_filter(true)

	serve_item_offer_parent.visible = true

	var item_to_offer_copy = GLShareholderOfferState.items_to_offer.duplicate()

	# get random item for card 1
	var item_1 = item_to_offer_copy.pick_random()
	item_to_offer_copy.erase(item_1)

	# get random item for card 2
	var item_2 = item_to_offer_copy.pick_random()
	item_to_offer_copy.erase(item_2)
	
	var item_3 = item_to_offer_copy.pick_random()
	item_to_offer_copy.erase(item_3)

	# set cards
	item_offer_card_1.update(item_1)
	item_offer_card_2.update(item_2)
	item_offer_card_3.update(item_3)


func handle_card_picked(offer_card: TextureRect) -> void:
	
	
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
	
	GLEventNoticeManagerBus.emit_signal('toggle_hide_event_notice', true)

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


func toggle_display_lock(toggle_value: bool) -> void:
	

	
	if toggle_value:
		header_label.visible = true
		blur_bg.visible = true

		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true

	else:
		header_label.visible = false
		blur_bg.visible = false

		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false


func toggle_mouse_filter(toggle_value: bool) -> void:
	if toggle_value:
		serve_item_offer_parent.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		serve_item_offer_parent.mouse_filter = Control.MOUSE_FILTER_IGNORE
