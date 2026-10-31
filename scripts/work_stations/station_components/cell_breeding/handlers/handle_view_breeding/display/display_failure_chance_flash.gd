extends Node

# Components
@onready var failure_chance_symbol: TextureRect = $"../../../BreedingUI/CellLoader/BreedingView/FailureChanceDisplay/FailureChanceSymbol"
@onready var left_failure_chance_label: Label = $"../../../BreedingUI/CellLoader/BreedingView/FailureChanceDisplay/LeftFailureChanceDisplay/TotalFailureChance/FailureChancePercant"
@onready var right_failure_chance_label: Label = $"../../../BreedingUI/CellLoader/BreedingView/FailureChanceDisplay/RightFailureDisplay/TotalFailureChance/FailureChancePercant"

# Timer
@onready var flash_delay_timer: Timer = $FlashDelayTimer

# Settings
const DANGER_THRESHOLD: float = 50.0
const SINGLE_DANGER_FLASH_DELAY: float = 0.5
const BOTH_DANGER_FLASH_DELAY: float = 0.25

const NORMAL_COLOR: Color = Color.WHITE
const DANGER_COLOR: Color = Color.RED

const NORMAL_SCALE: Vector2 = Vector2.ONE
const DANGER_SCALE: Vector2 = Vector2(1.3, 1.3)

# State
var left_side_danger: bool = false
var right_side_danger: bool = false
var flash_red: bool = false

var scale_tween: Tween


func _ready() -> void:
	flash_delay_timer.one_shot = false
	flash_delay_timer.timeout.connect(_handle_flash_delay_timer_timeout)

	failure_chance_symbol.pivot_offset = failure_chance_symbol.size * 0.5


func _display(cell_1: BrainCell, cell_2: BrainCell) -> void:
	_reset()

	var left_chance: float = 0.0
	var right_chance: float = 0.0

	if cell_1:
		left_chance = GAMECellBreeder.failure_chance_helper._get_total_failure_chance(
			cell_1,
			false
		)

	if cell_2:
		right_chance = GAMECellBreeder.failure_chance_helper._get_total_failure_chance(
			cell_2,
			false
		)

	left_side_danger = left_chance > DANGER_THRESHOLD
	right_side_danger = right_chance > DANGER_THRESHOLD

	if not left_side_danger and not right_side_danger:
		return

	var both_dangerous: bool = left_side_danger and right_side_danger

	flash_delay_timer.wait_time = (
		BOTH_DANGER_FLASH_DELAY
		if both_dangerous
		else SINGLE_DANGER_FLASH_DELAY
	)
	flash_delay_timer.start()

	toggle_scale_tween(both_dangerous)


func _reset() -> void:
	flash_delay_timer.stop()

	left_side_danger = false
	right_side_danger = false
	flash_red = false

	update_display()
	toggle_scale_tween(false)


func _handle_flash_delay_timer_timeout() -> void:
	flash_red = not flash_red
	update_display()


func update_display() -> void:
	var display_color: Color = DANGER_COLOR if flash_red else NORMAL_COLOR

	left_failure_chance_label.modulate = (
		display_color if left_side_danger else NORMAL_COLOR
	)
	right_failure_chance_label.modulate = (
		display_color if right_side_danger else NORMAL_COLOR
	)
	failure_chance_symbol.modulate = (
		display_color
		if left_side_danger or right_side_danger
		else NORMAL_COLOR
	)


func toggle_scale_tween(toggle_value: bool) -> void:
	if scale_tween:
		scale_tween.kill()
		scale_tween = null

	failure_chance_symbol.scale = NORMAL_SCALE

	if not toggle_value:
		return

	failure_chance_symbol.pivot_offset = failure_chance_symbol.size * 0.5

	scale_tween = create_tween().set_loops()
	scale_tween.set_trans(Tween.TRANS_SINE)
	scale_tween.set_ease(Tween.EASE_IN_OUT)

	scale_tween.tween_property(
		failure_chance_symbol,
		"scale",
		DANGER_SCALE,
		0.3
	)
	scale_tween.tween_property(
		failure_chance_symbol,
		"scale",
		NORMAL_SCALE,
		0.5
	)
