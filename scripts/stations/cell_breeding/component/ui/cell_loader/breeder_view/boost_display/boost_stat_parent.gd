extends Node

@export var selected_stat : String = "strength"

# components
@onready var parent_boost_display : Control = $"../.."
@onready var detect_hover_rect : ColorRect = $DetectHover
@onready var highlight : Sprite2D = $Highlight
@onready var death_alert : Sprite2D = $DeathAlert
@onready var handle_stat_selected : Node = $"../../../../../../../HandleBoostDisplay/HandleStatSelected"

var hovered : bool =  false
var selected : bool = false # property is set by handlers



func _ready() -> void:
	detect_hover_rect.connect("mouse_entered", _handle_mouse_entered)
	detect_hover_rect.connect("mouse_exited", _handle_mouse_exited)

func _process(_delta: float) -> void: 
	
	if hovered : 
		if Input.is_action_just_pressed('attack') : 
			handle_stat_selected._handle(parent_boost_display.side, selected_stat)
			

func _handle_mouse_entered() -> void:
	
	hovered = true
	highlight.visible = true


func _handle_mouse_exited() -> void:
	
	hovered = false 
	
	if not selected : 	
		highlight.visible = false
