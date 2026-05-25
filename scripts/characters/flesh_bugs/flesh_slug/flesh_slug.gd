extends Node

# componnets
@onready var state_machine : Node = $StateMachine


var can_be_hurt : bool = false

## DETECT PLAYER AREA ##
func _on_detect_player_body_entered(body: Node3D) -> void:
	if body.is_in_group('player') :
		state_machine.switch_state(state_machine.State.ATTACK)		
		


func _on_detect_player_body_exited(body: Node3D) -> void:
	if body.is_in_group('player') :
		state_machine.switch_state(state_machine.State.FOLLOW_PLAYER)		
#########################
