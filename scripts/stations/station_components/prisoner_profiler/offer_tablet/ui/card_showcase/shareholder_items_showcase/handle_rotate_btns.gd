extends Node

@onready var flavor_text_label: Label = $"../ItemGallery/FlavorTextLabel"
@onready var item_type_label: Label = $"../ItemGallery/ItemTypeLabel"
@onready var item_img: TextureRect = $"../ItemGallery/ItemImg"

@onready var t_defect_shot: Texture2D = preload("res://models/share_holder_offer_card/item_defect.png")
@onready var t_hidden_shot: Texture2D = preload("res://models/share_holder_offer_card/item_hidden_shot.png")
@onready var t_steroid: Texture2D = preload("res://models/share_holder_offer_card/item_steroid.png")
@onready var t_ice_cube: Texture2D = preload("res://models/share_holder_offer_card/item_ice_cube.png")
@onready var t_scissors: Texture2D = preload("res://models/share_holder_offer_card/item_scissors.png")

var possible_item_types: Array[String] = [
	"defect_shot",
	"hidden_shot",
	"steroid",
	"ice_cube",
	"scissors",
]

var current_item_index: int = 0


func _ready() -> void:
	current_item_index = 1 if possible_item_types.size() > 1 else 0
	_display_current_item()


func _handle(btn_direction: String) -> void:
	match btn_direction:
		"forward":
			current_item_index = wrapi(
				current_item_index + 1, 0, possible_item_types.size()
			)
		"backward":
			current_item_index = wrapi(
				current_item_index - 1, 0, possible_item_types.size()
			)
		_:
			push_warning("Unknown item rotation direction: " + btn_direction)
			return

	_display_current_item()


func _display_current_item() -> void:
	var selected_type: String = possible_item_types[current_item_index]
	var selected_item: UseableOfferItem

	for item: UseableOfferItem in GLShareholderOfferState.all_items:
		if item.item_type == selected_type:
			selected_item = item
			break

	if selected_item == null:
		push_error("Could not find item in all_items: " + selected_type)
		return

	item_type_label.text = selected_type.replace("_", " ").capitalize()
	flavor_text_label.text = selected_item.flavor_text
	item_img.texture = _get_item_texture(selected_type)


func _get_item_texture(item_type: String) -> Texture2D:
	match item_type:
		"defect_shot":
			return t_defect_shot
		"hidden_shot":
			return t_hidden_shot
		"steroid":
			return t_steroid
		"ice_cube":
			return t_ice_cube
		"scissors":
			return t_scissors
		_:
			push_error("No image assigned for item type: " + item_type)
			return null
