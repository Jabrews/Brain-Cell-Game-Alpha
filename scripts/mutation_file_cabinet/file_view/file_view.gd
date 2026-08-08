extends Control 


@onready var mutation_type_label : Label = $MutationType
@onready var mutation_info_label : Label = $MutationInfo

@onready var audio_manager : Node3D = $"../AudioManager"

func _load_file_view(file_info : FileInfo) :
	toggle_mouse_filter(true)
	mutation_type_label.text = file_info.type
	mutation_info_label.text = file_info.text
	get_tree().paused = true

func _close_file_view() :
	toggle_mouse_filter(false)
	audio_manager.play_page_close()
	visible = false
	get_parent().file_being_viewed = false
	get_tree().paused = false 

func toggle_mouse_filter(toggle_value : bool ) :
	if toggle_value : 
		mouse_filter = Control.MOUSE_FILTER_STOP
	else : 
		mouse_filter = Control.MOUSE_FILTER_IGNORE
