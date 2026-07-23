extends MutationNode 

func _ready_overide() :
	pass

func _start() :
	print('airborne start')
	
	await get_tree().create_timer(1.0).timeout
	print('airborne timer ended')
	random_event_finished()
	
	

func _stop() :
	print('airborne stop')
