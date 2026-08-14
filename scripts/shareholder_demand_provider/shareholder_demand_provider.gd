extends Node

# components
@onready var detect_player_area : Area3D = $DetectPlayerArea
@onready var card_container : Control = $CardContainer
@onready var demand_card_1 : TextureRect = $CardContainer/Card1Container
@onready var demand_card_2 : TextureRect = $CardContainer/Card2Container
@onready var demand_card_3 : TextureRect = $CardContainer/Card3Container
@onready var blur_bg : ColorRect = $BlurBg
@onready var header_label : Label = $HeaderLabel

var player_in_provider_area : bool = false
var player_viewing_cards : bool = false
var card_selected : bool = false

func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_next_round)
	detect_player_area.connect('body_entered', _handle_body_entered)
	detect_player_area.connect('body_exited', _handle_body_exited)
	
	toggle_display_lock(false)
	toggle_mouse_filter(false)

func _process(_delta: float) -> void:
	if player_in_provider_area and not player_viewing_cards: 
		if Input.is_action_just_pressed('interact') : 
			toggle_player_viewing_cards(true)

func _handle_next_round() :
	card_selected = false
			
### AREA ###
func _handle_body_entered(body : Node3D) : 
	if body.is_in_group('player') :
		GLShareholderDemandState.emit_signal('toggle_player_entered_provider_area', true)
		player_in_provider_area = true

func _handle_body_exited(body : Node3D) : 
	if body.is_in_group('player') :
		GLShareholderDemandState.emit_signal('toggle_player_entered_provider_area', false)
		player_in_provider_area = false
	
### TOGGLE ###
func toggle_player_viewing_cards(toggle_value : bool )	 :
	card_container.visible = toggle_value
	header_label.visible = toggle_value 
	blur_bg.visible = toggle_value 
	player_viewing_cards = toggle_value
	toggle_display_lock(toggle_value)
	toggle_mouse_filter(toggle_value)
	GLShareholderDemandState.emit_signal('toggle_player_entered_provider_area', !toggle_value)
	GLEventNoticeManagerBus.emit_signal('toggle_hide_event_notice', toggle_value)
	
	if toggle_value : 
		load_cards()
	else :
		pass
	
	
#### EXIT BTN ###
func _handle_exit_btn_pressed() :
	toggle_player_viewing_cards(false)

#### LOAD CARDS ####
func load_cards() :
	
	var round_demands : Array[DemandItem] = []
	match GLGameManagerBus.current_round : 
		1 :
			round_demands = GLShareholderDemandState.round_1_demand_items
		2 : 
			round_demands = GLShareholderDemandState.round_2_demand_items
	
	var round_demand_copy = round_demands.duplicate()
	
	var offer_1 : DemandItem = round_demand_copy.pick_random()
	round_demand_copy.erase(offer_1)	
	
	var offer_2 : DemandItem = round_demand_copy.pick_random()
	round_demand_copy.erase(offer_2)	

	var offer_3 : DemandItem = round_demand_copy.pick_random()
	round_demand_copy.erase(offer_3)	
	
	demand_card_1.update(offer_1)
	demand_card_2.update(offer_2)
	demand_card_3.update(offer_3)
	
### CARD PICKED ####
func _handle_card_picked(offer_card: TextureRect) -> void:
	
	var tween := create_tween()

	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	# move card downward off screen
	tween.tween_property(offer_card, "position:y", offer_card.position.y + 300, 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	# fade out
	tween.parallel().tween_property(offer_card, "modulate:a", 0.0, 0.8)

	await tween.finished


#### DISPLAY HELPERS ####
func toggle_display_lock(toggle_value: bool) -> void:
	
	if toggle_value:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true

	else:
		header_label.visible = false
		blur_bg.visible = false

		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false


func toggle_mouse_filter(toggle_value: bool) -> void:
	if toggle_value:
		card_container.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		card_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
########################
