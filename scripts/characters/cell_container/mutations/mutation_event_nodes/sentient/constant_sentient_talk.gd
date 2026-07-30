extends MutationNode 

@onready var speech_bubble : Node3D = $SpeechBubble

var possible_text : Array[String]= [
	'poop',
	'someone ate my dog',
	'someone ate my dog. whom also ate my cat',
	'someone ate my dog. whom also ate my cat. help me \n\nacutally i changed my mind i dont want to live anymore...',
]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :
		speech_bubble._load_text(possible_text.pick_random())
		
		
func _ready_overide() :
	random_event = false
	stop_on_pickup = false
	

func _start() :
	pass

func _stop() :
	print('sentient stop')
