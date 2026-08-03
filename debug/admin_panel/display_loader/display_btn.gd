extends Control



# components
@onready var button : ColorRect = $ColorRect
@onready var parent_display_loader : Control = $"../.."

@export var display_type : String

var hovered_over : bool = false

func _ready() -> void:
	button.connect('mouse_entered', func(): hovered_over = true)
	button.connect('mouse_exited', func(): hovered_over = false)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('attack') :
		if hovered_over : 
			parent_display_loader._handle_display_btn_pressed(display_type)
	
