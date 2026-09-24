extends Control

# components
@onready var background : ColorRect = $BtnBg
@onready var confirm_label : Label = $ConfirmLabel
@onready var handle_back_btn : Node = $"../../../HandleBackBtn"

var hovered : bool = false


func _ready() -> void:
	background.connect('mouse_entered', _handle_mouse_entered)
	background.connect('mouse_exited', _handle_mouse_exited)
	
func _process(_delta: float) -> void: 
	if hovered : 
		if Input.is_action_just_pressed('attack') :
			handle_back_btn._handle()

	
func _handle_mouse_entered() :
	
	hovered = true
		
	background.scale = Vector2(1.2, 1.2)
	confirm_label.scale = Vector2(1.2, 1.2)
	

func _handle_mouse_exited() :
	
	hovered = false
	
	background.scale = Vector2(1.0, 1.0)
	confirm_label.scale = Vector2(1.0, 1.0)
	
