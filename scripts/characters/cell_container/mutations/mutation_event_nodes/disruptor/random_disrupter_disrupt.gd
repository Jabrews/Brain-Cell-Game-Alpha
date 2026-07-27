extends MutationNode 

@onready var particle_manager : Node3D = $ParticleManager
# sounds
@onready var disrupt_start : AudioStreamPlayer3D = $DisruptStart
@onready var disrupt_failed : AudioStreamPlayer3D = $DisruptFailed
@onready var disrupt_success : AudioStreamPlayer3D = $DisruptSuccess
# status labels
@onready var hack_success_label : Label3D = $HackSuccess
@onready var hack_failed_label : Label3D = $HackFailed

func _ready_overide() :
	random_event = true
	stop_on_pickup = false
	

func _start() :
	
	print('start')
	
	disrupt_start.play()	
	
	particle_manager._start()
	
	await get_tree().create_timer(7.0).timeout
	
	particle_manager._stop()
	particle_manager.visible = false
	
	# fail
	#disrupt_failed.play()
	#
	#await disrupt_failed.finished
	
	# success	
	disrupt_success.play()
	hack_success_label._start_blink()
	await get_tree().create_timer(3.0).timeout
	
	random_event_finished()

func _stop() :
	pass
	print('end')
