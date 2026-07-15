extends Node

# game manager componnet
@export var mutations_seen_manager : Node 

# componnets
@onready var file_cam : Camera3D = $cam
@onready var file_manager : Node = $FileManager
@onready var click_to_view_label : Label = $ClickToView
@onready var press_to_leave_label : Label = $ToLeave
@onready var file_view : Control = $FileView
@onready var audio_manager : Node3D = $AudioManager

var file_being_viewed : bool = false

var player_in_cabinet_area : bool = false
var player_viewing_files : bool = false

func _process(_delta: float) -> void: 
	
	if player_in_cabinet_area : 
		if Input.is_action_just_pressed('interact') :
			
			if file_being_viewed : 
				return
			
			if not player_viewing_files:
				set_player_viewing_file_cabinet(true)
			else : 
				set_player_viewing_file_cabinet(false)			
	
func set_player_viewing_file_cabinet(toggle_value : bool) :
	player_viewing_files = toggle_value
	file_cam.current = toggle_value
	press_to_leave_label.visible = toggle_value
	GLMutationFileCabinetBus.emit_signal('toggle_player_entered_cabinet_area', !toggle_value)
	GLPlayerState.emit_signal('lock_player_position', toggle_value)
	file_manager._refresh_file_info_seen_by_player()
	
	if toggle_value :	
		audio_manager.play_cabinet_open()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else :
		audio_manager.play_cabinet_close()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		click_to_view_label.visible = false

func _display_file_view(file_info : FileInfo) :
	audio_manager.play_page_chose()
	file_view.visible = true
	file_being_viewed = true
	click_to_view_label.visible = false
	file_view._load_file_view(file_info)

	

func _on_detect_player_area_body_entered(body: Node3D) -> void:
	if body.is_in_group('player') :
		GLMutationFileCabinetBus.emit_signal('toggle_player_entered_cabinet_area', true)
		player_in_cabinet_area = true


func _on_detect_player_area_body_exited(body: Node3D) -> void:
	if body.is_in_group('player') :
		GLMutationFileCabinetBus.emit_signal('toggle_player_entered_cabinet_area', false)
		player_in_cabinet_area = false
