extends Node


# Component labels
@onready var header_time_left_label: Label3D = $"../HeaderTimeLeft"
@onready var min_seconds_label: Label3D = $"../MinSeconds"
@onready var parent_manager: Node3D = $".."


# Sounds
@onready var s_30_second_beep: AudioStreamPlayer3D = $"../30SecondBeep"
@onready var s_regular_click: AudioStreamPlayer3D = $"../RegularClick"
@onready var s_last_15_click: AudioStreamPlayer3D = $"../Last15Click"


# Every 30 seconds
var every_30_scale_tween: Tween
@export var every_30_scale_max: Vector3 = Vector3(1.5, 1.5, 1.5)
var last_30_second_trigger: int = -1


# Last 30 seconds
var bounce_vertical_tween: Tween
@export var bounce_height: float = 0.08
@export var bounce_duration: float = 0.35

var original_parent_position: Vector3


# Last 15 seconds
var shake_horizontal_tween: Tween
var last_15_scale_tween: Tween

@export var last_15_scale_max: Vector3 = Vector3(1.2, 1.2, 1.2)


# Font color
var red_font_color: Color = Color.RED


var increased_regular_click: bool = false
var stop_flashing_red: bool = false
var last_30_started: bool = false


func _ready() -> void:
	original_parent_position = parent_manager.position


func _refresh_visuals(
	time_to_exsplode: int,
	max_time: int
) -> void:
	var prevent_click: bool = false

	########################
	# EVERY 30 SECONDS     #
	########################

	if (
		time_to_exsplode > 0
		and time_to_exsplode < max_time
		and time_to_exsplode % 30 == 0
		and last_30_second_trigger != time_to_exsplode
	):
		last_30_second_trigger = time_to_exsplode
		visual_every_30()
		prevent_click = true

	########################
	# LAST 30 SECONDS      #
	########################

	if time_to_exsplode <= 30:
		stop_flashing_red = true

		header_time_left_label.modulate = red_font_color
		min_seconds_label.modulate = red_font_color

		if not last_30_started:
			last_30_started = true

			if bounce_vertical_tween:
				bounce_vertical_tween.kill()

			bounce_vertical_tween = create_tween()
			bounce_vertical_tween.set_loops()
			bounce_vertical_tween.set_trans(Tween.TRANS_SINE)
			bounce_vertical_tween.set_ease(Tween.EASE_IN_OUT)

			bounce_vertical_tween.tween_property(parent_manager, "position:y", original_parent_position.y + bounce_height, bounce_duration)
			bounce_vertical_tween.tween_property(parent_manager, "position:y", original_parent_position.y - bounce_height, bounce_duration)

	########################
	# LAST 15 SECONDS      #
	########################

	if time_to_exsplode <= 10:
		if last_15_scale_tween:
			last_15_scale_tween.kill()

		last_15_scale_tween = create_tween()

		last_15_scale_tween.tween_property(header_time_left_label, "scale", last_15_scale_max, 0.1)
		last_15_scale_tween.parallel().tween_property(min_seconds_label, "scale", last_15_scale_max, 0.1)

		last_15_scale_tween.tween_property(header_time_left_label, "scale", Vector3.ONE, 0.15)
		last_15_scale_tween.parallel().tween_property(min_seconds_label, "scale", Vector3.ONE, 0.15)

	########################
	# RED FLASH UNDER 60   #
	########################

	if (
		time_to_exsplode <= 60
		and time_to_exsplode > 30
		and not stop_flashing_red
	):
		flash_red_each_second()

	########################
	# CLICK SOUNDS         #
	########################

	if not prevent_click:
		if time_to_exsplode > 15:
			if (
				time_to_exsplode <= 60
				and not increased_regular_click
			):
				s_regular_click.volume_db += 10.0
				s_regular_click.max_distance += 5.0
				increased_regular_click = true

			s_regular_click.play()

		else:
			s_last_15_click.play()


func visual_every_30() -> void:
	if every_30_scale_tween:
		every_30_scale_tween.kill()

	every_30_scale_tween = create_tween()

	s_30_second_beep.play()

	every_30_scale_tween.tween_property(header_time_left_label, "scale", every_30_scale_max, 0.25)
	every_30_scale_tween.parallel().tween_property(min_seconds_label, "scale", every_30_scale_max, 0.25)

	await every_30_scale_tween.finished

	header_time_left_label.modulate = red_font_color
	min_seconds_label.modulate = red_font_color

	every_30_scale_tween = create_tween()

	every_30_scale_tween.tween_property(header_time_left_label, "scale", Vector3.ONE, 0.25)
	every_30_scale_tween.parallel().tween_property(min_seconds_label, "scale", Vector3.ONE, 0.25)

	await every_30_scale_tween.finished

	# Do not turn white again if we have entered the final 30 seconds.
	if not stop_flashing_red:
		header_time_left_label.modulate = Color.WHITE
		min_seconds_label.modulate = Color.WHITE


func flash_red_each_second() -> void:
	header_time_left_label.modulate = red_font_color
	min_seconds_label.modulate = red_font_color

	await get_tree().create_timer(0.25).timeout

	if stop_flashing_red:
		return

	header_time_left_label.modulate = Color.WHITE
	min_seconds_label.modulate = Color.WHITE
