extends MeshInstance3D

# components
@onready var border_flash_delay_timer : Timer =$BorderFlashDelayTimer
@onready var border_flash_duration_timer : Timer = $BorderFlashDurationTimer
@onready var highlight_border : MeshInstance3D = $HiglightBorder

@export var float_height: float = 0.10
@export_range(0.0, 5.0, 0.05) var float_frequency: float = 0.5

var _starting_position: Vector3
var _float_time: float = 0.0


func _ready() -> void:
	_starting_position = position
	
	border_flash_delay_timer.connect('timeout', _handle_border_flash_delay_timeout)	
	border_flash_duration_timer.connect('timeout', _handle_border_flash_duration_timeout)	
	

func _activate() :
	border_flash_duration_timer.start()
	border_flash_delay_timer.start()
	
	highlight_border.visible = true
	
func _stop() : 
	border_flash_duration_timer.stop()
	border_flash_delay_timer.stop()
	
	highlight_border.visible = false 
	


func _process(delta: float) -> void:
	_float_time += delta
	position.y = _starting_position.y + sin(
		_float_time * TAU * float_frequency
	) * float_height


func _handle_border_flash_delay_timeout() :
	highlight_border.visible = !highlight_border.visible   

func _handle_border_flash_duration_timeout() :
	border_flash_delay_timer.stop()
	highlight_border.visible = false
