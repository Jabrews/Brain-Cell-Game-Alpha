extends Node

# component
@onready var plug_distance_area : Area3D = $PlugDistanceArea
@export var plug : RigidBody3D 
@onready var s_plug_snap: AudioStreamPlayer3D = $PlugSnap


func _ready() -> void:
	plug_distance_area.connect('body_exited', _handle_body_exited)

func _handle_body_exited(body : Node3D) :
	if body.is_in_group('player') :
		if plug.state_machine.curr_state.name == 'PickedUp' : 
			s_plug_snap.play()
			await get_tree().create_timer(0.5).timeout
			GLPlayerState.emit_signal('increment_player_health', -1)
			plug.state_machine.switch_state(plug.state_machine.State.IDLE)
			plug.global_position = plug.after_snap_pos 
				
			
			
		
			
			
		
		
