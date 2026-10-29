extends Node

# Components
@onready var handle_preview_card_selected: Node = $"../../../../Logic/OfferTablet/HandlePreviewCardSelected"
@onready var hover_border_rect: ColorRect = $HoverBorder
@onready var select_border_rect: ColorRect = $SelectBorder
@onready var detect_area: ColorRect = $DetectArea

@export var corrisponding_card_index: int = 0
@export_range(0.05, 2.0) var selected_flash_speed: float = 0.4
@export_range(0.0, 1.0) var selected_flash_low_alpha: float = 0.3
@export_range(0.0, 1.0) var selected_flash_high_alpha: float = 1.0

var border_state: String = "none"
var hovered: bool = false
var selected_border_flash_tween: Tween


func _ready() -> void:
	detect_area.connect("mouse_entered", _handle_mouse_entered)
	detect_area.connect("mouse_exited", _handle_mouse_exited)
	detect_area.connect("focus_entered", _handle_mouse_entered)
	detect_area.connect("focus_exited", _handle_mouse_exited)


func _process(_delta: float) -> void:
	if hovered:
		if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("interact"):
			handle_preview_card_selected.handle(corrisponding_card_index)


func _handle_mouse_entered() -> void:
	hovered = true

	if border_state == "selected":
		_start_selected_border_flash()
		return

	if border_state != "active":
		hover_border_rect.visible = true


func _handle_mouse_exited() -> void:
	hovered = false
	hover_border_rect.visible = false
	_stop_selected_border_flash()


func _reset() -> void:
	_stop_selected_border_flash()
	border_state = "none"
	hover_border_rect.visible = false
	select_border_rect.visible = false


func _handle_selected() -> void:
	if border_state == "selected":
		_reset()
		GLPrisonerProfilerComponentsBus.emit_signal("play_sound", "tablet_unselect")
		hover_border_rect.visible = hovered
	else:
		border_state = "selected"
		hover_border_rect.visible = false
		select_border_rect.visible = true
		GLPrisonerProfilerComponentsBus.emit_signal("play_sound", "tablet_select")

		if hovered:
			_start_selected_border_flash()


func _start_selected_border_flash() -> void:
	_stop_selected_border_flash()

	select_border_rect.visible = true
	select_border_rect.modulate.a = selected_flash_high_alpha

	selected_border_flash_tween = create_tween().set_loops()
	selected_border_flash_tween.set_trans(Tween.TRANS_SINE)
	selected_border_flash_tween.set_ease(Tween.EASE_IN_OUT)
	selected_border_flash_tween.tween_property(
		select_border_rect,
		"modulate:a",
		selected_flash_low_alpha,
		selected_flash_speed
	)
	selected_border_flash_tween.tween_property(
		select_border_rect,
		"modulate:a",
		selected_flash_high_alpha,
		selected_flash_speed
	)


func _stop_selected_border_flash() -> void:
	if selected_border_flash_tween and selected_border_flash_tween.is_running():
		selected_border_flash_tween.kill()

	select_border_rect.modulate.a = selected_flash_high_alpha
