extends Control

@onready var button_bg : ColorRect = $ColorRect2
@onready var retry_label : Label = $RetryLabel

@export var scale_up_vector : Vector2 = Vector2(0.1, 0.1)
@export var hover_time : float = 0.2

var scale_hover_tween : Tween
var is_hovered : bool = false


func _ready() -> void:
	button_bg.connect("mouse_entered", _handle_mouse_entered)
	button_bg.connect("mouse_exited", _handle_mouse_exited)


func _process(_delta : float) -> void:
	if is_hovered:
		if Input.is_action_just_pressed("attack"):
			_handle_pressed()


func _handle_mouse_entered() -> void:
	is_hovered = true
	_toggle_hover(true)


func _handle_mouse_exited() -> void:
	is_hovered = false
	_toggle_hover(false)


func _toggle_hover(toggle_value : bool) -> void:
	
	if scale_hover_tween:
		scale_hover_tween.kill()
	
	scale_hover_tween = create_tween()
	scale_hover_tween.set_parallel(true)
	
	
	if toggle_value:
		
		scale_hover_tween.tween_property(
			retry_label,
			"scale",
			Vector2.ONE + scale_up_vector,
			hover_time
		)
		
		scale_hover_tween.tween_property(
			button_bg,
			"scale",
			Vector2.ONE + scale_up_vector,
			hover_time
		)
	
	else:
		
		scale_hover_tween.tween_property(
			retry_label,
			"scale",
			Vector2.ONE,
			hover_time
		)
		
		scale_hover_tween.tween_property(
			button_bg,
			"scale",
			Vector2.ONE,
			hover_time
		)


func _handle_pressed() -> void:
	get_tree().reload_current_scene()
	
	
	
	
