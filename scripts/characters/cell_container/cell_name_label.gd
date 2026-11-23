extends Label3D

@export_range(0.0, 1.0) var low_opacity: float = 0.3
@export_range(0.0, 1.0) var high_opacity: float = 1.0
@export_range(0.05, 5.0) var fade_duration: float = 0.5
@export var flash_on_start: bool = false

var cell_picked_up: bool = false
var showing_stat_display: bool = false
var opacity_tween: Tween


func _ready() -> void:
	_toggle_flash(flash_on_start)


func _load_name(cell_name: String) -> void:
	text = cell_name


func _toggle_cell_picked_up(toggle_value: bool) -> void:
	cell_picked_up = toggle_value
	_update_visibility()


func _toggle_showing_stat_display(toggle_value: bool) -> void:
	showing_stat_display = toggle_value
	_update_visibility()


func _update_visibility() -> void:
	visible = not cell_picked_up and not showing_stat_display


func _toggle_flash(toggle_value: bool) -> void:
	if opacity_tween:
		opacity_tween.kill()
		opacity_tween = null

	modulate.a = high_opacity
	outline_modulate.a = high_opacity

	if not toggle_value:
		return

	opacity_tween = create_tween().set_loops()
	opacity_tween.set_trans(Tween.TRANS_SINE)
	opacity_tween.set_ease(Tween.EASE_IN_OUT)

	opacity_tween.tween_property(
		self, "modulate:a", low_opacity, fade_duration
	)
	opacity_tween.parallel().tween_property(
		self, "outline_modulate:a", low_opacity, fade_duration
	)

	opacity_tween.tween_property(
		self, "modulate:a", high_opacity, fade_duration
	)
	opacity_tween.parallel().tween_property(
		self, "outline_modulate:a", high_opacity, fade_duration
	)
