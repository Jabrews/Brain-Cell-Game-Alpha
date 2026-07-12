extends Node

@export var mutation_manager : Node 

# componnets
@onready var file_cam : Camera3D = $cam
@onready var file_manager : Node = $FileManager
@onready var click_to_view_label : Label = $ClickToView


var player_in_cabinet_area : bool = false
var player_viewing_files : bool = false

func _process(_delta: float) -> void: 
	
	if player_in_cabinet_area : 
		if Input.is_action_just_pressed('interact') :
			if not player_viewing_files:
				set_player_viewing_file_cabinet(true)
			else : 
				set_player_viewing_file_cabinet(false)			
	
func set_player_viewing_file_cabinet(toggle_value : bool) :
	player_viewing_files = toggle_value
	file_cam.current = toggle_value
	GLMutationFileCabinetBus.emit_signal('toggle_player_entered_cabinet_area', !toggle_value)
	GLPlayerState.emit_signal('lock_player_position', toggle_value)
	
	if toggle_value :	
		file_manager._refresh_file_info_seen_by_player()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else :
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		click_to_view_label.visible = false
	

func _on_detect_player_area_body_entered(body: Node3D) -> void:
	if body.is_in_group('player') :
		GLMutationFileCabinetBus.emit_signal('toggle_player_entered_cabinet_area', true)
		player_in_cabinet_area = true


func _on_detect_player_area_body_exited(body: Node3D) -> void:
	if body.is_in_group('player') :
		GLMutationFileCabinetBus.emit_signal('toggle_player_entered_cabinet_area', false)
		player_in_cabinet_area = false
