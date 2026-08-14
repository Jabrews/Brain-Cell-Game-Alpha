extends Node

# components

@onready var btn_bg: ColorRect = $ColorRect
@onready var parent_shareholder_demand_provider: Node3D = $"../.."

var btn_hovered: bool = false
var original_color: Color


func _ready() -> void:
	original_color = btn_bg.color

	btn_bg.connect('mouse_entered', _handle_mouse_entered)
	btn_bg.connect('mouse_exited', _handle_mouse_exited)

func _process(_delta: float) -> void:
	if btn_hovered:
		if Input.is_action_just_pressed("attack"):
			parent_shareholder_demand_provider._handle_exit_btn_pressed()


func _handle_mouse_entered() -> void:
	
	btn_hovered = true

	var tween := create_tween()

	tween.tween_property(
		btn_bg,
		"color",
		original_color.lerp(Color.WHITE, 0.45),
		0.12
	)


func _handle_mouse_exited() -> void:
	
	btn_hovered = false
	

	var tween := create_tween()

	tween.tween_property(
		btn_bg,
		"color",
		original_color,
		0.12
	)
