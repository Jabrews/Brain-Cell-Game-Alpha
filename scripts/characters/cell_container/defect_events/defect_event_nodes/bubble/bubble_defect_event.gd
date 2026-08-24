extends DefectEventNode

# componnets
@onready var increment_defect_delay_timer : Timer = $IncrementDefectDelay
@onready var helper_defect_shake : Node = $DefectShake
@onready var shake_threshold_helper : Node = $ShakeThresholdHelper
@onready var particle_manager : Node3D = $ParticleManager
# sound components
@onready var s_bubble_idle : AudioStreamPlayer3D = $Sounds/BubbleIdle
@onready var s_bubbles_popping : AudioStreamPlayer3D = $Sounds/BubblePopping
@onready var s_shake_rattle : AudioStreamPlayer3D = $Sounds/ShakeRattle
@onready var s_bubble_end : AudioStreamPlayer3D = $Sounds/BubbleEnd


@export var increment_defect_delay_wait_time : float = 1.0

var ending : bool = false


func _ready_overide() -> void:
	increment_defect_delay_timer.wait_time = increment_defect_delay_wait_time
	increment_defect_delay_timer.connect('timeout', _handle_increment_defect_delay_timer)
	
func _start() -> void:
	increment_defect_delay_timer.start()
	helper_defect_shake._toggle_shake(true)
	s_bubble_idle.play()

func _handle_increment_defect_delay_timer() :
	
	# update designated cell refrence
	var designated_brain_cell : BrainCell = parent_brain_cell_container.designated_brain_cell
	
	# emit defect increase 
	GLCellManagerBus.emit_signal('cell_container_jolt_increase_cell_defect', designated_brain_cell, 10)
	

func _toggle_cell_picked_up(toggle_value: bool) -> void:
	
	if ending  : 
		return
	

	shake_threshold_helper._toggle_detect_shake_threshold(toggle_value)
	
	if toggle_value : 
		s_bubble_idle.stop()
	else :
		s_bubble_idle.play()
		

func _update_shake_progress(shake_percant : float) :
	shake_percant = snapped(shake_percant, 0.25)
	
	particle_manager._handle_shake_progress(shake_percant)

	match shake_percant:
		0.25:
			s_bubbles_popping.play()
		0.50:
			s_bubbles_popping.play()
		0.75:
			s_bubbles_popping.play()		
		1.00:
			_stop()
	
	

func _stop() -> void:
	
	s_bubble_end.play()	
	helper_defect_shake._toggle_shake(false)
	
	increment_defect_delay_timer.stop()
	ending = true
	
	particle_manager.spawn_bubble_delay_timer.stop()
		
	for bubble : StaticBody3D in particle_manager.bubble_parent_node.get_children() :
		bubble.kill_bubble()
	
	if s_bubble_end.playing :
		await s_bubble_end.finished
	
	parent_brain_cell_container.scale = Vector3(1, 1, 1)
	

	delete_event_notice()
	queue_free()
