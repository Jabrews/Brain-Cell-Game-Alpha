extends Sprite3D

# components
@onready var overtime_dissipate_timer : Timer =  $OvertimeDissipate

var curr_dissipate_value : float = 0.0

func _ready() -> void:
	
	self.material_override = self.material_override.duplicate()
	overtime_dissipate_timer.connect('timeout', _handle_overtime_dissipate_timer_timeout)

func _process(_delta: float) -> void: 
	if Input.is_action_just_pressed('debug1') :
		curr_dissipate_value = 0.0
		overtime_dissipate_timer.start()
	
func _handle_overtime_dissipate_timer_timeout() :
	
	curr_dissipate_value += 0.1
	
	self.material_override.set_shader_parameter("progress", curr_dissipate_value)
	
	pass
		
