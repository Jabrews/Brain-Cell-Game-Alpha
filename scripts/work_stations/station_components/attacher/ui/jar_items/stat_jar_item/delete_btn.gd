extends Control

# components
@onready var delete_btn_bg : ColorRect = $BG
@onready var hover_border : ColorRect = $HoverBorder
@onready var delete_hint : Control = $DeleteHint
# 
@onready var parent_stat_jar_item : Control = $".."
@onready var handle_delete_jar_btn : Node = $"../../../../../../../Logic/BtnHandlers/HandleJarDeleteBtn"

var hovered : bool = false

func _process(_delta: float) -> void: 
	if hovered :
		if Input.is_action_just_pressed('attack') : 
			var jar_item: StatJarItem  = parent_stat_jar_item.corrisponding_stat_jar_item 
			handle_delete_jar_btn._handle(jar_item)
		


func _on_mouse_entered() -> void:
	hover_border.visible = true
	delete_hint.visible = true


func _on_mouse_exited() -> void:
	hover_border.visible = false 
	delete_hint.visible = false 
