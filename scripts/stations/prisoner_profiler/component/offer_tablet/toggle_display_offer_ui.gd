extends Node

# components
@onready var offer_ui : Control = $"../../../OfferUi"
@onready var hover_preview_cards: Array[Control] = [
	$"../../../OfferUi/OfferBody/PreviewCardsHover/PreviewCardHover1",
	$"../../../OfferUi/OfferBody/PreviewCardsHover/PreviewCardHover2",
	$"../../../OfferUi/OfferBody/PreviewCardsHover/PreviewCardHover3"
]

func _ready() -> void:
	_toggle(false)

func _toggle(toggle_value : bool) :
	
	offer_ui.visible = toggle_value	
	
	toggle_display_lock(toggle_value)
	
	if toggle_value  :
		GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'tablet_open')
	
func toggle_display_lock(toggle_value: bool) -> void:
	
	if toggle_value:
		GLHideUiBus.emit_signal('toggle_hide_ui', true)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		GLPlayerState.emit_signal('lock_player_position', true)
		
		await get_tree().process_frame
		
		var focus_preview_card_detect_area: ColorRect = get_first_focus_preview_card()
		
		focus_preview_card_detect_area.grab_focus()

	else:
		GLHideUiBus.emit_signal('toggle_hide_ui', false)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		GLPlayerState.emit_signal('lock_player_position', false)

func get_first_focus_preview_card() -> ColorRect : 
	
	var selected_preview_card_detect_area : ColorRect = null	
	
	
	for hover_card : Control in hover_preview_cards: 
		if hover_card.border_state == 'selected': 
			selected_preview_card_detect_area = hover_card.detect_area

	if selected_preview_card_detect_area : 
		return selected_preview_card_detect_area
	
	else : 
		return hover_preview_cards[1].detect_area
	
	
