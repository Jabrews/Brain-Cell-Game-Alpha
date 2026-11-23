extends AspectRatioContainer

# components
@onready var handle_exit_btn : Node = $"../../../../../Logic/BtnHandlers/HandleExitBtn"
@onready var hint_parent : Control = $HintParent
@onready var btn_bg : ColorRect = $BG

var hovered : bool = false

func _ready() -> void:
	btn_bg.mouse_entered.connect(_handle_mouse_entered)
	btn_bg.mouse_exited.connect(_handle_mouse_exited)
	btn_bg.focus_entered.connect(_handle_mouse_entered)
	btn_bg.focus_exited.connect(_handle_mouse_exited)

func _process(_delta: float) -> void:
	if hovered:
		if Input.is_action_just_pressed('attack') : 
			handle_exit_btn._handle()
		if Input.is_action_just_pressed('interact') :
			handle_exit_btn._handle()
			

func _handle_mouse_entered() -> void:
	hovered = true
	btn_bg.scale = Vector2(1.10, 1.10)
	modulate = Color.LIGHT_GRAY
	hint_parent.visible = true

func _handle_mouse_exited() -> void:
	hovered = false
	btn_bg.scale = Vector2(1.0, 1.0)
	modulate = Color.WHITE
	hint_parent.visible = false
