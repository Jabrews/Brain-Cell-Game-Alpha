extends Node


# Components
@onready var face_sprite: Sprite3D = $FaceSprite


# Textures
@onready var smile: Texture2D = preload(
	"res://models/mutations/constant_lonley_starvation/lonley_smile.png"
)

@onready var frown: Texture2D = preload(
	"res://models/mutations/constant_lonley_starvation/lonley_frown.png"
)

@onready var cry: Texture2D = preload(
	"res://models/mutations/constant_lonley_starvation/lonley_cry.png"
)


var smile_bounce_tween: Tween
var frown_shake_tween: Tween
var cry_scale_tween: Tween

var original_position: Vector3
var original_scale: Vector3

var white_flash_material: StandardMaterial3D


func _ready() -> void:
	original_position = face_sprite.position
	original_scale = face_sprite.scale

	create_white_flash_material()


func switch_icon(face_type: String) -> void:
	reset()

	match face_type:
		"smile":
			face_sprite.texture = smile
			smile_bounce()

		"frown":
			face_sprite.texture = frown
			shake_frown()

		"cry":
			face_sprite.texture = cry
			cry_scale()


func reset() -> void:
	if smile_bounce_tween:
		smile_bounce_tween.kill()
		smile_bounce_tween = null

	if frown_shake_tween:
		frown_shake_tween.kill()
		frown_shake_tween = null

	if cry_scale_tween:
		cry_scale_tween.kill()
		cry_scale_tween = null

	face_sprite.position = original_position
	face_sprite.scale = original_scale

	white_flash_material.albedo_color = Color(
		1.0,
		1.0,
		1.0,
		0.0
	)


func smile_bounce() -> void:
	smile_bounce_tween = create_tween()
	smile_bounce_tween.set_loops()

	smile_bounce_tween.tween_property(
		face_sprite,
		"position:y",
		original_position.y + 0.1,
		0.3
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	smile_bounce_tween.tween_property(
		face_sprite,
		"position:y",
		original_position.y,
		0.1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	smile_bounce_tween.tween_property(
		face_sprite,
		"position:y",
		original_position.y - 0.1,
		0.3
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	smile_bounce_tween.tween_property(
		face_sprite,
		"position:y",
		original_position.y,
		0.1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


# Shake horizontally while quickly shrinking and growing.
func shake_frown() -> void:
	frown_shake_tween = create_tween()
	frown_shake_tween.set_loops()

	frown_shake_tween.tween_property(
		face_sprite,
		"position:x",
		original_position.x + 0.06,
		0.06
	)

	frown_shake_tween.tween_property(
		face_sprite,
		"position:x",
		original_position.x - 0.06,
		0.12
	)

	frown_shake_tween.tween_property(
		face_sprite,
		"position:x",
		original_position.x,
		0.06
	)

# Grow large, flash white, then return to normal.
func cry_scale() -> void:
	cry_scale_tween = create_tween()

	cry_scale_tween.tween_property(
		face_sprite,
		"scale",
		original_scale * 1.5,
		0.15
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	cry_scale_tween.parallel().tween_property(
		white_flash_material,
		"albedo_color",
		Color(1.0, 1.0, 1.0, 1.0),
		0.08
	)

	cry_scale_tween.tween_interval(0.05)

	cry_scale_tween.tween_property(
		face_sprite,
		"scale",
		original_scale,
		0.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	cry_scale_tween.parallel().tween_property(
		white_flash_material,
		"albedo_color",
		Color(1.0, 1.0, 1.0, 0.0),
		0.15
	)


func create_white_flash_material() -> void:
	white_flash_material = StandardMaterial3D.new()

	white_flash_material.transparency = (
		BaseMaterial3D.TRANSPARENCY_ALPHA
	)

	white_flash_material.shading_mode = (
		BaseMaterial3D.SHADING_MODE_UNSHADED
	)

	white_flash_material.albedo_color = Color(
		1.0,
		1.0,
		1.0,
		0.0
	)

	white_flash_material.emission_enabled = true
	white_flash_material.emission = Color.WHITE
	white_flash_material.emission_energy_multiplier = 2.0

	face_sprite.material_overlay = white_flash_material
