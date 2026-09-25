extends Control

# display components
@onready var btn_bg: ColorRect = $ColorRect
@onready var reset_label: Label = $ResetLabel
@onready var hint: Control = $Hint

# components
@onready var handle_reset_btn : Node  = $"../../../HandleResetBtn"


var hovered: bool = false
var active: bool = false

var toggle_tween: Tween
var hover_tween: Tween

var final_position: Vector2 = Vector2(77.0, -290.0)


func _ready() -> void:
	btn_bg.mouse_entered.connect(_handle_mouse_entered)
	btn_bg.mouse_exited.connect(_handle_mouse_exited)
	btn_bg.focus_entered.connect(_handle_mouse_entered)
	btn_bg.focus_exited.connect(_handle_mouse_exited)

	hint.visible = false
	visible = false


func _process(_delta: float) -> void:
	if hovered : 
		if Input.is_action_just_pressed('attack') or Input.is_action_just_pressed('interact') : 
			handle_reset_btn._handle()

func reset(): 
	pass


func _toggle_active(toggle_value: bool) -> void:
	
	# prevent duplicate calls
	if toggle_value == active : 
		return
	
	active = toggle_value

	if toggle_tween:
		toggle_tween.kill()

	if hover_tween:
		hover_tween.kill()

	if toggle_value:

		GLBreedingComponetsBus.emit_signal(
			"breeder_play_sound",
			"reset_btn_enter"
		)

		visible = true
		position = final_position
		scale = Vector2.ZERO

		toggle_tween = create_tween()
		toggle_tween.set_trans(Tween.TRANS_BACK)
		toggle_tween.set_ease(Tween.EASE_OUT)

		toggle_tween.tween_property(
			self,
			"scale",
			Vector2.ONE,
			0.25
		)

		await toggle_tween.finished

		if active:
			_start_idle_hover()

	else:

		hint.visible = false

		toggle_tween = create_tween()
		toggle_tween.set_trans(Tween.TRANS_BACK)
		toggle_tween.set_ease(Tween.EASE_IN)

		toggle_tween.tween_property(
			self,
			"scale",
			Vector2.ZERO,
			0.2
		)

		await toggle_tween.finished

		if not active:
			visible = false


func _start_idle_hover() -> void:
	if hover_tween:
		hover_tween.kill()

	hover_tween = create_tween()
	hover_tween.set_loops()
	hover_tween.set_trans(Tween.TRANS_SINE)
	hover_tween.set_ease(Tween.EASE_IN_OUT)

	hover_tween.tween_property(
		self,
		"position",
		final_position + Vector2(0, -2),
		0.7
	)

	hover_tween.tween_property(
		self,
		"position",
		final_position + Vector2(0, 2),
		0.7
	)


func _handle_mouse_entered() -> void:
	if not active:
		return

	hovered = true

	btn_bg.scale = Vector2(1.1, 1.1)
	reset_label.scale = Vector2(1.1, 1.1)

	hint.visible = true


func _handle_mouse_exited() -> void:
	hovered = false

	btn_bg.scale = Vector2.ONE
	reset_label.scale = Vector2.ONE

	hint.visible = false
