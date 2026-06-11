extends Node

# componnets
@onready var time_left_label  : Label = $TimeLeft
@onready var progress_bar : TextureProgressBar = $ProgressBar

func _ready() -> void:
	time_left_label.text = str(IVHiddenStats.max_time_to_discover_hidden)

func _handle_increment(current_value : int) :
	var time_left = IVHiddenStats.max_time_to_discover_hidden - current_value	
	time_left_label.text = str(time_left)
	update_bar(current_value)

func _reset_increment() :
	time_left_label.text = str(IVHiddenStats.max_time_to_discover_hidden)
	update_bar(0)

func update_bar(current_value : int) :
	progress_bar.max_value = IVHiddenStats.max_time_to_discover_hidden 
	progress_bar.value = current_value

	
	
	
	
	
