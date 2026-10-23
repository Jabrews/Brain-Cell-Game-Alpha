extends Label

@export var rotate_btn_direction: String = "forward"

@onready var handle_rotate_btns: Node = $"../../../HandleRotateBtns"

var hovered: bool = false
var base_scale: Vector2
var base_modulate: Color
var press_tween: Tween


func _ready() -> void:
	base_scale = scale
	base_modulate = modulate

	mouse_entered.connect(_handle_mouse_entered)
	mouse_exited.connect(_handle_mouse_exited)
	focus_entered.connect(_handle_mouse_entered)
	focus_exited.connect(_handle_mouse_exited)


func _process(_delta: float) -> void:
	if hovered and Input.is_action_just_pressed("attack") :
		handle_rotate_btns._handle(rotate_btn_direction)
		_flash_pressed()
	if hovered and Input.is_action_just_pressed('interact') :
		handle_rotate_btns._handle(rotate_btn_direction)
		_flash_pressed()	


func _handle_mouse_entered() -> void:
	hovered = true
	scale = base_scale * 1.4
	modulate = Color.WHITE


func _handle_mouse_exited() -> void:
	hovered = false
	scale = base_scale

	if press_tween:
		press_tween.kill()

	modulate = base_modulate


func _flash_pressed() -> void:
	
	GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'item_showcase_btn_pressed')
	
	if press_tween:
		press_tween.kill()

	modulate = Color.RED
	press_tween = create_tween()
	press_tween.tween_property(self, "modulate", Color.WHITE, 0.12)
