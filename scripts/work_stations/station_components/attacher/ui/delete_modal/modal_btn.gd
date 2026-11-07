extends Node

# components
@onready var bg : ColorRect = $BG
@onready var hover_border : ColorRect = $HoverBorder
@onready var handle_modal_btn : Node = $"../../../Logic/BtnHandlers/HandleModalBtn"

@export var btn_type : String = 'confirm'
var hovered : bool = false

func _ready() -> void:
	bg.connect('mouse_entered', _handle_mouse_entered)
	bg.connect('mouse_exited', _handle_mouse_exited)

func _process(_delta: float) -> void:
	if hovered : 
		if Input.is_action_just_pressed('attack') : 
			handle_modal_btn._handle(btn_type)

func _handle_mouse_entered():
	hovered = true
	hover_border.visible = true 
	
func _handle_mouse_exited():
	hovered = false 
	hover_border.visible = false 
