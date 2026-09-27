extends Node

# game manager componnet
@export var mutations_seen_manager : Node

# componnets
@onready var file_cam : Camera3D = $cam
@onready var file_manager : Node = $FileManager
@onready var click_to_view_label : Control = $ClickToView
@onready var press_to_leave_label : Control = $ToLeave
@onready var file_view : Control = $FileView
@onready var audio_manager : Node3D = $AudioManager
@onready var file_cabinet_interact_area : Area3D = $FileCabinetInteractArea

# grab focus component
@onready var file_1_controller_focus : Control = $Files/File/ControllerFocus

@onready var controller_focus_controls : Array[Control] = [
	$Files/File/ControllerFocus,
	$Files/File2/ControllerFocus, 
	$Files/File3/ControllerFocus, 
	$Files/File4/ControllerFocus, 
	$Files/File5/ControllerFocus, 
	$Files/File6/ControllerFocus, 
	$Files/File7/ControllerFocus, 
]


var file_being_viewed : bool = false
var player_viewing_files : bool = false

# prevents opening interact from instantly triggering exit
var ignore_interact : bool = false


func _process(_delta: float) -> void:
	
	if player_viewing_files :
		
		if Input.is_action_just_pressed('interact') :
			
			if ignore_interact :
				return
			
			if file_being_viewed :
				return
			
			else :
				
				if GAMEInputTypeDetector.input_type == 'controller' :
					return
				
				set_player_viewing_file_cabinet(false)
		
		
		if Input.is_action_just_pressed('drop_item') :
			
			if GAMEInputTypeDetector.input_type == 'controller' :
				
				if player_viewing_files :
					set_player_viewing_file_cabinet(false)


# NEW ENTRY METHOD
# called by your hologram / raycast interact component
func _handle_cabinet_interacted() -> void:
	
	if player_viewing_files :
		return
	
	if file_being_viewed :
		return
	
	ignore_interact = true
	
	set_player_viewing_file_cabinet(true)
	
	audio_manager.play_cabinet_open()
	
	# let the interact press used to open finish
	await get_tree().process_frame
	
	ignore_interact = false


func set_player_viewing_file_cabinet(toggle_value : bool) :
	player_viewing_files = toggle_value
	
	file_cam.current = toggle_value
	press_to_leave_label.visible = toggle_value
	
	GLMutationFileCabinetBus.emit_signal(
		'toggle_player_entered_cabinet_area',
		!toggle_value
	)
	
	GLPlayerState.emit_signal(
		'lock_player_position',
		toggle_value
	)
	
	file_manager._refresh_file_info_seen_by_player()
	
	
	if toggle_value :
		
		file_cabinet_interact_area.visible = false 
		
		
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		GLHideUiBus.emit_signal(
			'toggle_hide_ui',
			true
		)
		
		
		if GAMEInputTypeDetector.input_type == 'controller' :
			
			for controller_focus : Control in controller_focus_controls : 				
				controller_focus.focus_mode = Control.FOCUS_NONE
			
			
			await get_tree().process_frame
			
			
			for controller_focus : Control in controller_focus_controls : 				
				controller_focus.focus_mode = Control.FOCUS_ALL
			
			
			file_1_controller_focus.grab_focus()
	
	
	else :
		
		file_cabinet_interact_area.visible = true
		
		audio_manager.play_cabinet_close()
		
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		click_to_view_label.visible = false
		
		for controller_focus : Control in controller_focus_controls : 				
			controller_focus.focus_mode = Control.FOCUS_NONE
		
		GLHideUiBus.emit_signal(
			'toggle_hide_ui',
			false
		)


func _display_file_view(file_info : FileInfo) :
	
	audio_manager.play_page_chose()
	
	file_view.visible = true
	file_being_viewed = true
	
	click_to_view_label.visible = false
	
	file_view._load_file_view(file_info)
