extends MutationNode 

@onready var crystals_manager: Node3D = $CrystalManager

func _ready_overide() :
	random_event = true
	stop_on_pickup = false 
	
func _start() :
	
	# crystal idle 
	crystals_manager._create()
	
	await get_tree().create_timer(2.0).timeout
	
	# attack
	crystals_manager._attack_player()
	
	await get_tree().create_timer(10.0).timeout
	
	
	
	random_event_finished()

func _stop() :
	pass
