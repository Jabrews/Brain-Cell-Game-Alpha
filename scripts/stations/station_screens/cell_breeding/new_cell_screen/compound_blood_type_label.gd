extends Label

@onready var new_letter_delay: Timer = $NewLetterDelay

var possible_chars: Array[String] = [
	"O",
	"A",
	"B",
]


func _ready() -> void:
	new_letter_delay.timeout.connect(_handle_new_letter_delay)
	new_letter_delay.start()


func _handle_new_letter_delay() -> void:
	var old_letter: String = text
	var new_letter: String = old_letter
	
	while new_letter == old_letter:
		new_letter = possible_chars.pick_random()
	
	text = new_letter
