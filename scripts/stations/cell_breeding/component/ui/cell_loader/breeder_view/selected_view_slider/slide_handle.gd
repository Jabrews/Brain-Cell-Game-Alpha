extends Node

# components
@onready var slide_bg : ColorRect = $SlideBg
@onready var slide_hover : ColorRect = $SlideHover
@onready var arrow_label : Label = $Arrow

const OPEN_ARROW_ROTATION : float = 90.0
const OPEN_ARROW_POS : Vector2 = Vector2(40.0, 19.0)
const CLOSED_ARROW_ROTATION : float = 270.0
const CLOSED_ARROW_POS : Vector2 = Vector2(-6.0, 38.0)

var hovered : bool = false
var opened : bool = false

func _ready() -> void:
	slide_bg.connect('mouse_entered', _handle_mouse_entered)
	slide_bg.connect('mouse_exited', _handle_mouse_exited)

func _process(_delta: float) -> void: 
	if hovered : 
		if Input.is_action_just_pressed('attack') : 
			toggle_open()
			
func _handle_mouse_entered() :
	print('eneter')
	slide_hover.visible = true	
	hovered = true
	
func _handle_mouse_exited() :
	print('exit')
	slide_hover.visible = false
	hovered = false
	

func toggle_open(): 
	
	opened = !opened	
	
	if opened : 	
		arrow_label.position = OPEN_ARROW_POS
		arrow_label.rotation = OPEN_ARROW_ROTATION
	
	else : 
		arrow_label.position = CLOSED_ARROW_POS
		arrow_label.rotation = CLOSED_ARROW_ROTATION 
	

	
	
	
