extends Sprite3D

# components
@onready var overtime_dissipate_timer : Timer =  $OvertimeDissipate

var curr_dissipate_value : float = 0.0

func _ready() -> void:
	
	self.material_override = self.material_override.duplicate()
	overtime_dissipate_timer.connect('timeout', _handle_overtime_dissipate_timer_timeout)

func _toggle_effect(toggle_value : bool) :
	
	curr_dissipate_value = 0.0
	self.material_override.set_shader_parameter("progress", curr_dissipate_value)
	
	if toggle_value : 
		overtime_dissipate_timer.start()
	else : 
		overtime_dissipate_timer.stop()
	
func _handle_overtime_dissipate_timer_timeout() :
	
	curr_dissipate_value += 0.1
	
	self.material_override.set_shader_parameter("progress", curr_dissipate_value)
	
	pass
		
