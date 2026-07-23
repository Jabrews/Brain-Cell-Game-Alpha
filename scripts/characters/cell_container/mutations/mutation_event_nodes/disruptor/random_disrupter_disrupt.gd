extends MutationNode 

func _ready_overide() :
	pass

func _start() :
	print('disruptor start')
	
	await get_tree().create_timer(1.0).timeout
	print('disruptor timer ended')
	random_event_finished()

func _stop() :
	print('disruptor stop')
