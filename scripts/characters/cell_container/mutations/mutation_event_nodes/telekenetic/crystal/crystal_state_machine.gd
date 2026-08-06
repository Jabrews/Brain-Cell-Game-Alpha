extends Node

@onready var idle_state : Node = $Idle
@onready var attack_state : Node = $Attack
@onready var dead_state : Node = $Dead

enum State {
	IDLE,
	ATTACK,
	DEAD,
}

var states : Dictionary
var curr_state : Node


func _ready():

	states = {
		State.IDLE: idle_state,
		State.ATTACK : attack_state,
		State.DEAD : dead_state,
	}

	switch_state(State.IDLE)


func _process(delta):
	
	if curr_state and curr_state.has_method("state_process"):
		curr_state.state_process(delta)


func switch_state(new_state : State):

	# exit previous state
	if curr_state and curr_state.has_method("state_end"):
		curr_state.state_end()

	# set new state
	curr_state = states[new_state]

	# start new state
	if curr_state.has_method("state_start"):
		curr_state.state_start()

func get_current_state_name() -> String:
	for key in states:
		if states[key] == curr_state:
			return State.keys()[key].to_lower()
	
	return "unknown"
