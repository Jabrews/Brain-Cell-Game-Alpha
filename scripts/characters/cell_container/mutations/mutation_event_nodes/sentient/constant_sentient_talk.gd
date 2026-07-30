extends MutationNode 

@onready var speech_bubble : Node3D = $SpeechBubble


var sentient_dialouges : Array[Sentient_Dialogue] =[
	Sentient_Dialogue.new('hello this is some-\n\ntest text...', 'normal'),
	Sentient_Dialogue.new('hello this is some-\n\ntest text...', 'mad'),
	Sentient_Dialogue.new('hello this is some-\n\ntest text...\nya here me.. TEST TEXT', 'important'),
]


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :
		speech_bubble._start_text(sentient_dialouges.pick_random())
		
		
func _ready_overide() :
	random_event = false
	stop_on_pickup = false
	

func _start() :
	pass

func _stop() :
	print('sentient stop')
