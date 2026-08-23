extends DefectEventNode

# componnets
@onready var jolt_particles : GPUParticles3D = $JoltParticles
@onready var s_jolt_sound_loop : AudioStreamPlayer3D = $JoltSoundLoop
@onready var helper_defect_shake : Node = $DefectShake
@onready var increment_defect_delay_timer : Timer = $IncrementDefectDelay

@export var increment_defect_delay_wait_time : float = 5.0

func _ready_overide() -> void:
	increment_defect_delay_timer.wait_time = increment_defect_delay_wait_time
	increment_defect_delay_timer.connect('timeout', _handle_increment_defect_delay_timer)
	
	# for when its on interpreter. (it will have data)	
	GLDefectEventMangerBus.connect('stopped_jolt', _handle_stopped_jolt)
	

func _start() -> void:
	jolt_particles.emitting = true
	s_jolt_sound_loop.play()
	helper_defect_shake._toggle_shake(true)
	increment_defect_delay_timer.start()

func _handle_increment_defect_delay_timer() :
	
	# update designated cell refrence
	var designated_brain_cell : BrainCell = parent_brain_cell_container.designated_brain_cell
	
	# emit defect increase 
	GLCellManagerBus.emit_signal('cell_container_jolt_increase_cell_defect', designated_brain_cell, 45)
	

func _toggle_cell_picked_up(toggle_value: bool) -> void:

	if toggle_value:
		_stop()
	
# only for sickness spread by stat interpreter
func _handle_stopped_jolt(interpreter_stat_type : String) :
	
	if data['interpreter_stat_type'] : 	
		if data['interpreter_stat_type'] == interpreter_stat_type : 
			_stop()
	


func _stop() -> void:

	delete_event_notice()
	
	jolt_particles.emitting = false 
	s_jolt_sound_loop.stop()
	helper_defect_shake._toggle_shake(false)
	increment_defect_delay_timer.stop()
	

	queue_free()
