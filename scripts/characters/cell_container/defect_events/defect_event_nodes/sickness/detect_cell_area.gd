extends Area3D

# componnets
@onready var parent_sickness_defect_event : DefectEventNode = $".."
@onready var check_delay_timer : Timer = $CheckDelay


func _ready() -> void:
	
	check_delay_timer.start()	
	
	check_delay_timer.connect('timeout', _handle_check_delay_timer)
	connect('body_entered', _handle_body_entered)
	

func _handle_body_entered(body : Node3D) :
	if body.is_in_group('brain_cell_container') :
		
		# prevent from activating on self
		var parent_cell_name : String =	parent_sickness_defect_event.parent_brain_cell_container.designated_brain_cell.name
		if body.designated_brain_cell.name == parent_cell_name : 
			return
	
		GLDefectEventMangerBus.emit_signal('initate_defect_event_cell_container', 'sickness', body.designated_brain_cell.name,  true, {})
	

func _handle_check_delay_timer() :
	monitoring = !monitoring
