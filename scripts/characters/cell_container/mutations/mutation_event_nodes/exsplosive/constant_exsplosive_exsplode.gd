extends MutationNode 

# components
# timer
@onready var increment_second_timer : Timer = $IncrementSecond
# timer labels parent
@onready var timer_labels_manager : Node3D = $TimerLabelsManager
# particle manager
@onready var exsplode_particle_manager : Node3D = $ExsplodeParticleManager
# sounds
@onready var s_exsplode : AudioStreamPlayer3D = $Exsplode
@onready var s_shine : AudioStreamPlayer3D = $Shine
# detect exsplode area
@onready var detect_exsplode_entities_area : Area3D = $DetectExsplodeEntities

@export var time_to_exsplode : int = 120
@export var max_time_before_expslode : int = 120

# components
func _ready_overide() :
	
	random_event = false
	stop_on_pickup = false
	
	timer_labels_manager.visible = false	
	
	attempt_to_get_saved_exsplosive_state()
	
	increment_second_timer.start()
	
	# connect	
	increment_second_timer.connect('timeout', _handle_increment_second_timer_timeout)
	
	
func _start() :
	unhide_mutation()


func _handle_increment_second_timer_timeout() :
	
	time_to_exsplode -= 1
	
	if time_to_exsplode <= 0 : 	
		handle_blow_up()		
		return
		
		
	
	timer_labels_manager._refresh_timer_labels(time_to_exsplode)
	
	
	if not timer_labels_manager.visible: 
		timer_labels_manager.visible = true
	
	
	

func attempt_to_get_saved_exsplosive_state() -> void:
	var cell_name: String = (
		parent_cell_container.designated_brain_cell.name
	)

	if not GLMutationExsplosiveState.saved_exsplosive_state.has(cell_name):
		return

	var saved_time_to_exsplode: int = (
		GLMutationExsplosiveState.saved_exsplosive_state[cell_name]
	)

	time_to_exsplode = saved_time_to_exsplode


func handle_blow_up() : 
	s_shine.play()
	increment_second_timer.stop()
	timer_labels_manager.visible = false
	parent_cell_container.container_mesh.visible = false	
	s_exsplode.play()
	detect_exsplode_entities_area.monitoring = true
	GLMutationExsplosiveState.emit_signal('shake_player_cam_from_exsplode')
	GLMutationExsplosiveState.emit_signal('create_exsplosion_decal', parent_cell_container.global_position)
	await get_tree().create_timer(0.1).timeout
	detect_exsplode_entities_area.monitoring = false 
	exsplode_particle_manager._show_particles()
	# kinda hacky but is exsplode partickke duration
	await get_tree().create_timer(1.1).timeout
	parent_cell_container.spawn_flesh_bug_on_death  = false
	GLCellManagerBus.emit_signal('delete_selected_collected_cell', parent_cell_container.designated_brain_cell)

		
		


func _stop() -> void:
	# Save info to dictionary for possible retrieval.
	var cell_name: String = (
		parent_cell_container.designated_brain_cell.name
	)

	GLMutationExsplosiveState.saved_exsplosive_state[cell_name] = (
		time_to_exsplode
	)

	# NOTE : When the cell is actually deleted, its state is removed in Global state script
	# kinda hacky but works
	
