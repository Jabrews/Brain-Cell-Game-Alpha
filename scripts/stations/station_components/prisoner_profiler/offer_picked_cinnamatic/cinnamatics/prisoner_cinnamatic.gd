# PrisonerCinnamatic.gd
extends Node

@onready var prisoner_camera: Camera3D = $PrisonerCamera

const STARTING_FOV: float = 90.0
const FINALE_FOV: float = 80.0
const ANIMATION_DURATION: float = 3.0


func _initate(offer_card: PrisonerOfferCard) -> bool:
	prisoner_camera.fov = STARTING_FOV
	prisoner_camera.current = true

	var half_duration := ANIMATION_DURATION * 0.5

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(prisoner_camera, "fov", FINALE_FOV, half_duration)
	tween.tween_callback(_spawn_prisoners.bind(offer_card))
	tween.tween_property(prisoner_camera, "fov", FINALE_FOV, half_duration)

	await tween.finished
	prisoner_camera.current = false
	return true


func _spawn_prisoners(offer_card: PrisonerOfferCard) -> void:
	GLPrisonerPicks.prisoners_to_pick = offer_card.prisoner_picks
	GLCellManagerBus.emit_signal("create_prisoner_cells", offer_card.prisoner_cells)
	GLPrisonerSpawnerBus.emit_signal(
		"get_newest_prisoner_cells",
		offer_card.prisoner_cells,
		offer_card
	)
