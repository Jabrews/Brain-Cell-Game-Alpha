extends Node

@onready var bar_sprite: Sprite2D = $"../StatDisplay/Bar"
@onready var locked_sprite: Sprite2D = $"../StatDisplay/Locked/LockedSprite"
@onready var locked_bg: ColorRect = $"../StatDisplay/Locked/LockedBG"

const BAR_ENABLED_COLOR := Color.YELLOW
const BAR_DISABLED_COLOR := Color("#8f8f00")
const BAR_MASK_ENABLED_COLOR := Color("#ebebeb")
const BAR_MASK_DISABLED_COLOR := Color("#ababab")

const LOCKED_ENABLED_MODULATE := Color.WHITE
const LOCKED_DISABLED_MODULATE := Color("#9c9c9c")

const LOCKED_BG_A_ENABLED := Color("#5e5d5c3c")
const LOCKED_BG_A_DISABLED := Color("#4a49483c")
const LOCKED_BG_B_ENABLED := Color("#05050545")
const LOCKED_BG_B_DISABLED := Color("#0a0a0a45")


func _toggle(toggle_value: bool) -> void:
	var bar_material := bar_sprite.material as ShaderMaterial
	var bg_material := locked_bg.material as ShaderMaterial

	if toggle_value:
		bar_material.set_shader_parameter("yellow_color", BAR_ENABLED_COLOR)
		bar_material.set_shader_parameter("mask_color", BAR_MASK_ENABLED_COLOR)
		locked_sprite.modulate = LOCKED_ENABLED_MODULATE
		bg_material.set_shader_parameter("color_a", LOCKED_BG_A_ENABLED)
		bg_material.set_shader_parameter("color_b", LOCKED_BG_B_ENABLED)
	else:
		bar_material.set_shader_parameter("yellow_color", BAR_DISABLED_COLOR)
		bar_material.set_shader_parameter("mask_color", BAR_MASK_DISABLED_COLOR)
		locked_sprite.modulate = LOCKED_DISABLED_MODULATE
		bg_material.set_shader_parameter("color_a", LOCKED_BG_A_DISABLED)
		bg_material.set_shader_parameter("color_b", LOCKED_BG_B_DISABLED)
