extends Control

# components
@onready var bg : ColorRect = $BtnBG
@onready var exit_label : Label = $ExitLabel
@onready var handle_boost_display : Node = $"../../../../../../../HandleBoostDisplay"

var hovered : bool = false
@export var side : String = 'left'

func _ready() -> void:
	bg.connect('mouse_entered', _handle_mouse_entered)
	bg.connect('mouse_exited', _handle_mouse_exited)
	bg.connect('focus_entered', _handle_mouse_entered)
	bg.connect('focus_exited', _handle_mouse_exited)

func _process(_delta: float) -> void:
	if hovered == true : 
		if Input.is_action_just_pressed('attack') or Input.is_action_just_pressed('interact') :
			handle_boost_display._close_boost_display(side)

func _handle_mouse_entered() :
	hovered = true
	bg.scale = Vector2(1.1, 1.1)
	exit_label.scale = Vector2(1.1, 1.1)
	bg.color = Color.LIGHT_GRAY


func _handle_mouse_exited() :
	hovered = false
	bg.scale = Vector2(1.0, 1.0)
	exit_label.scale = Vector2(1.0, 1.0)
	bg.color = Color.WHITE
			
