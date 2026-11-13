extends ColorRect

# components
@onready var handle_exit_btn : Node =$"../../../Logic/BtnHandlers/HandleExitBtn"
@onready var hint_parent : Control = $Hint

var hovered : bool = false

func _ready() -> void:
	mouse_entered.connect(_handle_mouse_entered)
	mouse_exited.connect(_handle_mouse_exited)

func _process(_delta: float) -> void:
	if hovered:
		if Input.is_action_just_pressed('attack') :
			handle_exit_btn._handle()

func _handle_mouse_entered() -> void:
	hovered = true
	scale = Vector2(1.05, 1.05)
	color = Color.LIGHT_GRAY
	hint_parent.visible = true

func _handle_mouse_exited() -> void:
	hovered = false
	scale = Vector2(1.0, 1.0)
	color = Color.WHITE
	hint_parent.visible = false
