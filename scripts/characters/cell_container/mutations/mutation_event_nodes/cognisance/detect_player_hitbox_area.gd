extends Area3D

# components
@onready var bite_confirm_delay_timer : Timer = $BiteConfirmDelay
@onready var parent_cognisance_mutation_node : Node3D = $".."
@onready var s_bite : AudioStreamPlayer3D = $"../Bite"

func _ready() -> void:
	connect('body_entered', _handle_body_entered)
	connect('body_exited', _handle_body_exited)
	
	bite_confirm_delay_timer.connect('timeout', bite_player)
	

func _handle_body_entered(body : Node3D) :
	if body.is_in_group('player') :
		bite_confirm_delay_timer.start()

func _handle_body_exited(body : Node3D) :
	if body.is_in_group('player') :
		bite_confirm_delay_timer.stop()
		
func bite_player() :
	# hurt player
	s_bite.play()
	GLPlayerState.emit_signal('increment_player_health', -2)
	parent_cognisance_mutation_node._handle_cell_looked_at()
