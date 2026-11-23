extends Node

@onready var new_items_possible_rect: TextureRect = $NewItemPossibleRect
@onready var old_items_possible_rect: TextureRect = $OldItemPossibleRect

var image_textures: Array[Texture2D] = [
	preload("res://models/share_holder_offer_card/item_hidden_shot.png"),
	preload("res://models/share_holder_offer_card/item_ice_cube.png"),
	preload("res://models/share_holder_offer_card/item_scissors.png"),
	preload("res://models/share_holder_offer_card/item_defect.png"),
	preload("res://models/share_holder_offer_card/item_steroid.png"),
]

const IMAGE_HOLD_TIME: float = 1.5
const TRANSITION_TIME: float = 0.5


func _ready() -> void:
	if image_textures.is_empty():
		return

	new_items_possible_rect.texture = image_textures[0]
	new_items_possible_rect.modulate.a = 1.0
	old_items_possible_rect.modulate.a = 0.0

	_cycle_images()


func _cycle_images() -> void:
	var current_index: int = 0

	while true:
		await get_tree().create_timer(IMAGE_HOLD_TIME).timeout

		var next_index: int = (current_index + 1) % image_textures.size()

		old_items_possible_rect.texture = new_items_possible_rect.texture
		old_items_possible_rect.modulate.a = 1.0

		new_items_possible_rect.texture = image_textures[next_index]
		new_items_possible_rect.modulate.a = 0.0

		var tween := create_tween()
		tween.set_trans(Tween.TRANS_LINEAR)

		tween.tween_property(
			new_items_possible_rect,
			"modulate:a",
			1.0,
			TRANSITION_TIME
		)

		tween.parallel().tween_property(
			old_items_possible_rect,
			"modulate:a",
			0.0,
			TRANSITION_TIME
		)

		await tween.finished
		current_index = next_index
