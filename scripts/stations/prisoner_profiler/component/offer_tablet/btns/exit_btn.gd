extends ColorRect

# handle components
@onready var toggle_display_offer_ui : Node = $"../../../Logic/OfferTablet/ToggleDisplayOfferUi"
@onready var hint_parent : Control = $Hint


var hovered : bool = false

func _ready() -> void:
	connect('mouse_entered', _handle_mouse_entered)
	connect('mouse_exited', _handle_mouse_exited)
	connect('focus_entered', _handle_mouse_entered)
	connect('focus_exited', _handle_mouse_exited)

func _handle_mouse_entered() :
	hint_parent.visible = true
	hovered = true
	scale = Vector2(1.05, 1.05)
	color = Color.LIGHT_GRAY

func _handle_mouse_exited() :	
	hint_parent.visible = false 
	hovered = false
	scale = Vector2(1.0, 1.0)
	color = Color.WHITE
	

func _process(_delta: float) -> void:
	if hovered == true : 
		if Input.is_action_just_pressed('attack') or Input.is_action_just_pressed('interact') :
			toggle_display_offer_ui._toggle(false)
			
			

			
			
			
			
