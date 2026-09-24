extends Node

@export var direction : String = "up"

# components
@onready var btn_bg : ColorRect = $BtnBG
@onready var hover_rect : ColorRect = $HoverRect
@onready var handle_charge_direction : Node = $"../../../../../../../HandleBoostDisplay/HandleChargeDirection"
@onready var parent_boost_display : Control = $"../.."

var active_color : Color = Color("#00ffff")
var inactive_color : Color = Color.WEB_GRAY

var available : bool = true
var hovered : bool = false
var selected : bool = false




func _ready() -> void:
	btn_bg.mouse_entered.connect(_handle_mouse_entered)
	btn_bg.mouse_exited.connect(_handle_mouse_exited)


func _process(_delta: float) -> void:
	if hovered and available:
		if Input.is_action_just_pressed("attack"):
			var side : String = parent_boost_display.side
			handle_charge_direction._toggle_btn_pressed(side, direction)


func _handle_mouse_entered() -> void:
	if not available:
		return
	
	hovered = true
	
	if not selected:
		hover_rect.visible = true
		hover_rect.modulate.a = 0.5


func _handle_mouse_exited() -> void:
	hovered = false
	
	if not selected:
		hover_rect.visible = false


func _toggle_available(toggle_value : bool) -> void:
	
	available = toggle_value
	
	if toggle_value:
		btn_bg.color = active_color
		btn_bg.modulate.a = 1.0
		
		if hovered and not selected:
			hover_rect.visible = true
			hover_rect.modulate.a = 0.5
	
	else:
		hovered = false
		selected = false
		
		btn_bg.color = inactive_color
		btn_bg.modulate.a = 0.5
		
		hover_rect.visible = false
		hover_rect.modulate.a = 0.0
