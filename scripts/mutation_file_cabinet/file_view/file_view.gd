extends Control 


@onready var mutation_type_label : Label = $MutationType
@onready var mutation_info_label : Label = $MutationInfo

@onready var audio_manager : Node3D = $"../AudioManager"

func _load_file_view(file_info : FileInfo) :
	mutation_type_label.text = file_info.type
	mutation_info_label.text = file_info.text

func _close_file_view() :
	audio_manager.play_page_close()
	visible = false
	get_parent().file_being_viewed = false
