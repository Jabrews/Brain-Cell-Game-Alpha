extends Node

var last_played_sound_index: int = -1

@onready var talking_sounds: Array[AudioStreamPlayer3D] = [
	$Normal1,
	$Normal2,
	$Normal3,

	$Mad1,
	$Mad2,
	$Mad3,

	$Important1,
	$Important2,
	$Important3
]


func _play_text_sound(character: String, mood: String) -> void:
	if character == " " or character == "\n":
		return

	var sound_range: Vector2i = _get_sound_range(mood)

	if sound_range == Vector2i(-1, -1):
		push_warning("Unknown dialogue mood: " + mood)
		return

	var selected_sound_index: int = randi_range(
		sound_range.x,
		sound_range.y
	)

	while selected_sound_index == last_played_sound_index:
		selected_sound_index = randi_range(
			sound_range.x,
			sound_range.y
		)

	talking_sounds[selected_sound_index].play()
	last_played_sound_index = selected_sound_index


func _get_sound_range(mood: String) -> Vector2i:
	match mood:
		"normal":
			return Vector2i(0, 2)

		"mad":
			return Vector2i(3, 5)

		"important":
			return Vector2i(6, 8)

		_:
			return Vector2i(-1, -1)


func _reset() -> void:
	last_played_sound_index = -1
