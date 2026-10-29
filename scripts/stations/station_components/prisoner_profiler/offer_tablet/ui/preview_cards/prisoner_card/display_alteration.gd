extends Node

# Parent components
@onready var parent_alteration: Control = $"../Alterations"
@onready var no_alterations_found_parent: Control = $"../Alterations/NoAlterationsFound"
@onready var explosive_parent: Control = $"../Alterations/Exsplosive"
# compoennt
@onready var parent_card_bg : ColorRect = $"../CardBg"

var alteration_parent_float_tween: Tween
var alteration_parent_org_pos_y: float


func _ready() -> void:
	parent_card_bg.material = parent_card_bg.material.duplicate()	
	alteration_parent_org_pos_y = parent_alteration.position.y


func _display(prisoner_card: PrisonerOfferCard) -> void:
	no_alterations_found_parent.visible = false
	explosive_parent.visible = false

	var alteration_found := false

	match prisoner_card.alteration:
		"":
			no_alterations_found_parent.visible = true

		"exsplosive":
			explosive_parent.visible = true
			alteration_found = true

		_:
			no_alterations_found_parent.visible = true

	_toggle_parent_float_tween(alteration_found)
	_toggle_preview_card_shimmer(alteration_found)


func _toggle_parent_float_tween(toggle_value: bool) -> void:
	if alteration_parent_float_tween:
		alteration_parent_float_tween.kill()
		alteration_parent_float_tween = null

	parent_alteration.position.y = alteration_parent_org_pos_y

	if not toggle_value:
		return

	alteration_parent_float_tween = create_tween()
	alteration_parent_float_tween.set_loops()
	alteration_parent_float_tween.set_trans(Tween.TRANS_SINE)
	alteration_parent_float_tween.set_ease(Tween.EASE_IN_OUT)

	alteration_parent_float_tween.tween_property(
		parent_alteration,
		"position:y",
		alteration_parent_org_pos_y + 2.0,
		0.5
	)
	alteration_parent_float_tween.tween_property(
		parent_alteration,
		"position:y",
		alteration_parent_org_pos_y - 2.0,
		1.0
	)
	alteration_parent_float_tween.tween_property(
		parent_alteration,
		"position:y",
		alteration_parent_org_pos_y,
		0.5
	)

func _toggle_preview_card_shimmer(toggle_value : bool) : 
	
	if toggle_value : 
		parent_card_bg.material.set_shader_parameter('shimmer_strength', 0.05)
		parent_card_bg.material.set_shader_parameter('scanline_density', 120.0)
	else : 
		parent_card_bg.material.set_shader_parameter('shimmer_strength', 0.00)
		parent_card_bg.material.set_shader_parameter('scanline_density', 90.0)
