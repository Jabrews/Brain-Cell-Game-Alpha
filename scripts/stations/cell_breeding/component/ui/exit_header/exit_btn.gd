extends ColorRect

# handle components
@onready var handle_display_ui : Node = $"../../../HandleDisplayUi"


var hovered : bool = false

func _ready() -> void:
	connect('mouse_entered', _handle_mouse_entered)
	connect('mouse_exited', _handle_mouse_exited)

func _handle_mouse_entered() :
	hovered = true
	scale = Vector2(1.2, 1.2)

func _handle_mouse_exited() :
	hovered = false
	scale = Vector2(1.0, 1.0)

func _process(_delta: float) -> void:
	if hovered == true : 
		if Input.is_action_just_pressed('attack') :
			handle_display_ui._toggle_display(false)
			
			

			
			
			
			
