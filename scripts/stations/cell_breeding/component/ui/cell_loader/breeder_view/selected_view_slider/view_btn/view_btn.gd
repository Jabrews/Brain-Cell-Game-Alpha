extends Node

# components
@onready var button_bg : ColorRect = $BG2
@onready var selected_border : Control = $SelectedBorder
@onready var btn_label : Label = $BtnLabel
@onready var scale_down_components : Array[Control] = [
	$BG2, $BG1, $BtnLabel
]

@export var info_section_type : String 
@export var label_text : String

var hovered : bool = false

var scale_down_tween : Tween

func _ready() -> void:
	button_bg.connect('mouse_entered', _handle_mouse_entered)
	button_bg.connect('mouse_exited', _handle_mouse_exited)
	
	btn_label.text = label_text 

func _process(_delta: float) -> void:
	if hovered : 
		if Input.is_action_just_pressed('attack') :
			_handle_btn_pressed()
			

func _handle_mouse_entered() :
	selected_border.visible = true
	hovered = true	
	
func _handle_mouse_exited() :
	selected_border.visible = false 
	hovered = false

func _handle_btn_pressed() :
	
	if scale_down_tween :
		return
	
	scale_down_tween = create_tween()
	
	# all scale down together
	scale_down_tween.set_parallel(true)
	
	for component : Control in scale_down_components :
		scale_down_tween.tween_property(
			component,
			"scale",
			Vector2(0.5, 0.5),
			0.15
		)
	
	# next phase
	scale_down_tween.set_parallel(false)
	scale_down_tween.tween_interval(0.01)
	scale_down_tween.set_parallel(true)
	
	# all scale back up together
	for component : Control in scale_down_components :
		scale_down_tween.tween_property(
			component,
			"scale",
			Vector2(1.0, 1.0),
			0.15
		)
	
	await scale_down_tween.finished
	scale_down_tween = null
