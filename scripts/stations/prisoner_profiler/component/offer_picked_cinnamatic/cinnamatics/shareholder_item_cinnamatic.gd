extends Node

signal offer_items_spawned

@onready var shareholder_item_camera: Camera3D = $ShareholderItemCamera

const INITIAL_ZOOM_DURATION: float = 1.5
const BEFORE_OFFER_DELAY: float = 0.5
const AFTER_OFFER_DELAY: float = 1.0
const STARTING_FOV: float = 80.0
const ENDING_FOV: float = 50.0

var _item_spawn_completed: bool = false


func _ready() -> void:
	GLShareholderOfferState.connect(
		"spawn_item_to_offer",
		_handle_spawn_item_to_offer
	)


func _initate(shareholder_items_card: ShareholderItemsCard) -> bool:
	shareholder_item_camera.fov = STARTING_FOV
	shareholder_item_camera.current = true

	var zoom_tween := create_tween()
	zoom_tween.tween_property(
		shareholder_item_camera,
		"fov",
		ENDING_FOV,
		INITIAL_ZOOM_DURATION
	)
	await zoom_tween.finished

	await get_tree().create_timer(BEFORE_OFFER_DELAY).timeout

	_item_spawn_completed = false
	GLShareholderOfferState.emit_signal(
		"serve_shareholder_offer_cards",
		shareholder_items_card.items
	)

	if not _item_spawn_completed:
		await offer_items_spawned

	await get_tree().create_timer(AFTER_OFFER_DELAY).timeout

	shareholder_item_camera.current = false
	return true


func _handle_spawn_item_to_offer(_useable_offer_item: UseableOfferItem) -> void:
	if _item_spawn_completed:
		return

	_item_spawn_completed = true
	offer_items_spawned.emit()
