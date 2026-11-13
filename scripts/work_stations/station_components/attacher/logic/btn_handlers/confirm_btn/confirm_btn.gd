extends Control

# components
@onready var bg : ColorRect = $BtnBg
@onready var hint_parent : Control = $Hint
@onready var handle_confirm_btn : Node = $"../../../Logic/BtnHandlers/HandleConfirmBtn"

var hovered : bool = false

func _ready() -> void:
	bg.connect('mouse_entered', _handle_mouse_entered)
	bg.connect('mouse_exited', _handle_mouse_exited)

func _process(_delta: float) -> void:
	if hovered :
		if Input.is_action_just_pressed('attack') :
			handle_confirm_btn._handle()

func _handle_mouse_entered() :
	bg.scale = Vector2(1.05, 1.05)
	bg.color = Color.LIGHT_GRAY
	hint_parent.visible = true
	hovered = true

func _handle_mouse_exited() :
	bg.scale = Vector2(1.00, 1.00)
	bg.color = Color.WHITE
	hint_parent.visible = false
	hovered = false
