extends MutationNode 

var idle_timer: float = 0.0

func _process(delta: float) -> void:
	idle_timer += delta

	if idle_timer >= 5.0:
		idle_timer = 0.0
		print("sentient idle appears")


func _ready_overide() :
	pass

func _start() :
	print('sentient start')

func _stop() :
	print('sentient stop')
