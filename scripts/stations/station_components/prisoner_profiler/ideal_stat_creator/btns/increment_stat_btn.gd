extends InteractableBtn

@export var increment_direction: String = "up"
@export var ACTIVE_DELAY_WAIT_TIME: float = 0.2
@export var INCREMENT_DELAY_WAIT_TIME : float = 0.15

@onready var handle_increment_stat_btn: Node = (
	$"../../../../Logic/IdealStatCreator/BtnHandlers/HandleIncrementStatBtn"
)
@onready var hold_increment_delay_timer: Timer = $HoldIncrementDelay
@onready var hold_active_delay_timer: Timer = (
	$"../IncrementStatDown/HoldActiveDelay"
)

var button_holding_possible: bool = false

func _overide_ready():
	
	hold_active_delay_timer.wait_time = ACTIVE_DELAY_WAIT_TIME
	hold_increment_delay_timer.wait_time = INCREMENT_DELAY_WAIT_TIME	
	
	hold_increment_delay_timer.timeout.connect(
		_on_hold_increment_delay_timeout
	)
	hold_active_delay_timer.timeout.connect(
		_on_hold_active_delay_timeout
	)


func _input(event: InputEvent) -> void:
	if button_holding_possible and event.is_action_released("interact"):
		button_holding_possible = false
		hold_increment_delay_timer.stop()
		hold_active_delay_timer.stop()


func _on_btn_interacted() -> void:
	handle_increment_stat_btn._handle(increment_direction)
	button_holding_possible = true
	hold_increment_delay_timer.start()


func _on_hold_increment_delay_timeout() -> void:
	if not button_holding_possible:
		return

	handle_increment_stat_btn._handle(increment_direction, true)
	hold_active_delay_timer.start()


func _on_hold_active_delay_timeout() -> void:
	if not button_holding_possible:
		return

	handle_increment_stat_btn._handle(increment_direction, true)
	hold_active_delay_timer.start()
