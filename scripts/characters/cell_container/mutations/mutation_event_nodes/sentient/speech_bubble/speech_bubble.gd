extends Node

# Helper components
@onready var update_container_basis: Node = $UpdateContainerBasis
@onready var update_label_styles: Node = $UpdateLabelStyles
@onready var text_sound_manager: Node3D = $TextSoundManager
# Bubble components
@onready var speech_bubble_label: Label = \
	$SpeechBubbleTV/SubViewport/ScreenTextSpeechBubble/VBoxContainer/PanelContainer/Label
@onready var mesh_instance: MeshInstance3D = $SpeechBubbleTV
@onready var text_increment_delay_timer: Timer = $TextIncrementDelay
# Audio
@onready var text_bubble_start: AudioStreamPlayer3D = $TextBubbleStart

@export var bubble_visible_duration: float = 5.0
@export var bubble_appear_duration: float = 0.5
@export var bubble_disappear_duration: float = 1.0
@export var maximum_dialogue_length: int = 147

var bubble_material: StandardMaterial3D
var bubble_fade_tween: Tween

# True from the moment dialogue starts until it completely fades out.
var text_is_loaded: bool = false

# Invalidates old typing, waiting, and fading functions when overridden.
var dialogue_sequence_id: int = 0


func _ready() -> void:
	_prepare_bubble_material()


func _start_text(
	sentient_dialogue: Sentient_Dialogue,
	override_current_text: bool = false
) -> bool:
	if not _dialogue_is_valid(sentient_dialogue):
		return false

	# Ignore this dialogue if another one is already active,
	# unless overriding was explicitly requested.
	if text_is_loaded and not override_current_text:
		return false

	text_is_loaded = true

	# Any previously running dialogue now has an outdated sequence ID.
	dialogue_sequence_id += 1
	var active_sequence_id: int = dialogue_sequence_id

	_prepare_new_dialogue(sentient_dialogue)

	await get_tree().process_frame

	# This dialogue may have been overridden during the frame wait.
	if active_sequence_id != dialogue_sequence_id:
		return false

	update_container_basis._set_starting_height()
	update_container_basis._update()
	
	_fade_bubble_in()
	text_bubble_start.play()
	
	await _type_dialogue(
		sentient_dialogue,
		active_sequence_id
	)

	if active_sequence_id != dialogue_sequence_id:
		return false

	await _finish_dialogue(active_sequence_id)
	
	return true


func _prepare_new_dialogue(
	sentient_dialogue: Sentient_Dialogue
) -> void:
	_cancel_fade_tween()

	speech_bubble_label.text = ""

	text_sound_manager._reset()
	update_label_styles._update(sentient_dialogue.mood)
	update_container_basis._reset()


func _type_dialogue(
	sentient_dialogue: Sentient_Dialogue,
	sequence_id: int
) -> void:
	for character_index in sentient_dialogue.text.length():
		if sequence_id != dialogue_sequence_id:
			return

		speech_bubble_label.text = sentient_dialogue.text.substr(
			0,
			character_index + 1
		)

		# Allow the Label and containers to recalculate their sizes.
		await get_tree().process_frame

		if sequence_id != dialogue_sequence_id:
			return

		update_container_basis._update()

		text_sound_manager._play_text_sound(
			sentient_dialogue.text[character_index],
			sentient_dialogue.mood
		)

		text_increment_delay_timer.start()
		await text_increment_delay_timer.timeout

func _finish_dialogue(sequence_id: int) -> void:
	text_sound_manager._reset()
	update_label_styles._reset()

	await get_tree().create_timer(
		bubble_visible_duration
	).timeout

	if sequence_id != dialogue_sequence_id:
		return

	# New dialogue can now start while this bubble fades away.
	text_is_loaded = false

	await _fade_bubble_out()

	# A new dialogue may have started during the fade.
	if sequence_id != dialogue_sequence_id:
		return

	speech_bubble_label.text = ""
	update_container_basis._reset()
func _dialogue_is_valid(
	sentient_dialogue: Sentient_Dialogue
) -> bool:
	
	if sentient_dialogue == null:
		return false

	if sentient_dialogue.text.is_empty():
		return false

	if sentient_dialogue.text.length() > maximum_dialogue_length:
		push_error(
			"Dialogue is too long: ",
			sentient_dialogue.text,
			" | ",
			sentient_dialogue.mood
		)

		return false

	return true


func _prepare_bubble_material() -> void:
	bubble_material = \
		mesh_instance.material_override as StandardMaterial3D

	if bubble_material == null:
		push_error(
			"SpeechBubbleTV requires a StandardMaterial3D material override."
		)
		return

	# Prevent alpha changes from affecting other meshes using this material.
	bubble_material = bubble_material.duplicate()
	mesh_instance.material_override = bubble_material

	bubble_material.transparency = \
		BaseMaterial3D.TRANSPARENCY_ALPHA

	_set_bubble_opacity(0.0)


func _fade_bubble_in() -> void:
	_tween_bubble_opacity(
		1.0,
		bubble_appear_duration
	)


func _fade_bubble_out() -> void:
	_tween_bubble_opacity(
		0.0,
		bubble_disappear_duration
	)

	if bubble_fade_tween:
		await bubble_fade_tween.finished


func _tween_bubble_opacity(
	target_opacity: float,
	duration: float
) -> void:
	if bubble_material == null:
		return

	_cancel_fade_tween()

	bubble_fade_tween = create_tween()

	bubble_fade_tween.tween_property(
		bubble_material,
		"albedo_color:a",
		target_opacity,
		duration
	)


func _set_bubble_opacity(opacity: float) -> void:
	if bubble_material == null:
		return

	var color: Color = bubble_material.albedo_color
	color.a = clampf(opacity, 0.0, 1.0)

	bubble_material.albedo_color = color


func _cancel_fade_tween() -> void:
	if bubble_fade_tween:
		bubble_fade_tween.kill()
		bubble_fade_tween = null
