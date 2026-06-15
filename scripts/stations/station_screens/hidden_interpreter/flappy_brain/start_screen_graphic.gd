extends Node

@onready var blur_effect : ColorRect = $ColorRect
@onready var title_card_label : Label = $TitleCard
@onready var press_space_label : Label = $PressSpace

var blur_material: ShaderMaterial

func _ready() -> void:
	blur_material = blur_effect.material as ShaderMaterial
	
	blur_material = blur_material.duplicate()
	blur_effect.material = blur_material

func toggle_start(toggle_value :bool) :
	if toggle_value :
		title_card_label.visible = true
		press_space_label.visible = true
		blur_material.set_shader_parameter('blur_amount', 3.769)
		blur_material.set_shader_parameter('tint_strength', 0.176)
	else : 
		title_card_label.visible = false 
		press_space_label.visible = false 
		blur_material.set_shader_parameter('blur_amount', 0.400)
		blur_material.set_shader_parameter('tint_strength', 0.020)
