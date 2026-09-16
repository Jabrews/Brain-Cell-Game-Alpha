extends Control

# components
@onready var background : ColorRect = $BtnBg
@onready var confirm_label : Label = $ConfirmLabel
@onready var hint : Control = $Hint
@onready var hint_label : Label = $Hint/HintText

var confirm_available : bool = false

var hovered : bool = false


func _ready() -> void:
	background.connect('mouse_entered', _handle_mouse_entered)
	background.connect('mouse_exited', _handle_mouse_exited)
	
	_toggle_confirm_available(false)


func _toggle_confirm_available(toggle_value : bool) :
	
	confirm_available = toggle_value
	
	if confirm_available : 	
		background.modulate.a = 1.0
		confirm_label.modulate.a = 1.0
	else : 
		background.modulate.a = 0.5
		confirm_label.modulate.a = 0.6
	
	
func _handle_mouse_entered() :
	
	if confirm_available :	
		hovered = true
		
		background.scale = Vector2(1.2, 1.2)
		confirm_label.scale = Vector2(1.2, 1.2)
	
	else : 
		toggle_hint(true)
	

func _handle_mouse_exited() :
	
	hovered = false
	
	background.scale = Vector2(1.0, 1.0)
	confirm_label.scale = Vector2(1.0, 1.0)
	
	toggle_hint(false)	
	

func toggle_hint(toggle_value : bool) :
	hint.visible = toggle_value
	
	if toggle_value : 
		hint_label.text = GLBreedingComponetsBus.reasons_confirm_invalid[0]
	
	

	
	
	
