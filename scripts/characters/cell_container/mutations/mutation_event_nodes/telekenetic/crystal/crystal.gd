extends Node

@onready var state_machine : Node = $CrystalStateMachine
@onready var detect_collision_area : Area3D = $DetectCollisionArea


func _ready() -> void:
	detect_collision_area.connect('body_entered', _handle_body_entered)

func _handle_body_entered(body : Node3D) :
	if body.is_in_group('player') : 
		# hurt player
		GLPlayerState.emit_signal('increment_player_health', -1)
	
	elif body.is_in_group('brain_cell_container') : 
		GLCellManagerBus.emit_signal('cell_hit_by_crystal', body.designated_brain_cell)
		
	state_machine.switch_state(state_machine.State.DEAD)
		
		
	
	
	
