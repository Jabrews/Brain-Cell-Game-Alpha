extends ColorRect

# handle components
@onready var handle_confirm_btn_pressed : Node = $"../../../Logic/OfferTablet/HandleConfirmBtnPressed"
@onready var confirm_hint : Control = $"../ConfirmHint"

var btn_active : bool = false

var hovered : bool = false

func _ready() -> void:
	connect('mouse_entered', _handle_mouse_entered)
	connect('mouse_exited', _handle_mouse_exited)
	connect('focus_entered', _handle_mouse_entered)
	connect('focus_exited', _handle_mouse_exited)
	
	_toggle_confirm_btn_active(false)

func _process(_delta: float) -> void:
	if hovered == true : 
		if Input.is_action_just_pressed('attack') or Input.is_action_just_pressed('interact') :
			handle_confirm_btn_pressed._handle()

func _toggle_confirm_btn_active(toggle_value : bool) : 
	btn_active = toggle_value
	
	if btn_active : 
		modulate.a = 1.0
	else : 
		modulate.a = 0.5

func _handle_mouse_entered() :
	hovered = true
	scale = Vector2(1.05, 1.05)
	color = Color.LIGHT_GRAY
	
	if not btn_active : 
		confirm_hint.visible = true
	

func _handle_mouse_exited() :
	hovered = false
	scale = Vector2(1.0, 1.0)
	color = Color.WHITE
	
	confirm_hint.visible = false
	
