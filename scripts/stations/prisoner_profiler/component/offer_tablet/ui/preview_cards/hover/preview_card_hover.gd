extends Node

# components
@onready var handle_preview_card_selected : Node = $"../../../../Logic/OfferTablet/HandlePreviewCardSelected"
@onready var hover_border_rect : ColorRect = $HoverBorder
@onready var select_border_rect : ColorRect = $SelectBorder
@onready var detect_area : ColorRect = $DetectArea

@export var corrisponding_card_index : int = 0 
var border_state : String = 'none'

var hovered : bool = false


func _ready() -> void:
	detect_area.connect('mouse_entered', _handle_mouse_entered)
	detect_area.connect('mouse_exited', _handle_mouse_exited)


func _process(_delta: float) -> void: 
	if hovered :
		if Input.is_action_just_pressed('attack') : 
			handle_preview_card_selected.handle(corrisponding_card_index)


func _handle_mouse_entered() :
	
	hovered = true	
	
	if border_state == 'active' :
		return
	
	hover_border_rect.visible = true
	

func _handle_mouse_exited() :
	
	hovered = false
	
	hover_border_rect.visible = false


func _reset() : 
	border_state = 'none' 
	hover_border_rect.visible = false
	select_border_rect.visible = false

func _handle_selected() : 
	if border_state == 'selected' : 
		_reset()
	else : 
		border_state = 'selected' 
		hover_border_rect.visible = false
		select_border_rect.visible = true
		
	



 
