extends Node

# components

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var time_label: Label = $Time


func _update_progress(time_spent: int) -> void:
	var max_time: int = IVHiddenStats.max_time_to_discover_hidden
	
	progress_bar.max_value = max_time
	progress_bar.value = time_spent 
	
	var time_remaining: int = max(max_time - time_spent, 0)

	if time_remaining >= 60:
		@warning_ignore("integer_division")
		var minutes: int = time_remaining / 60
		var seconds: int = time_remaining % 60

		time_label.text = "%d-%02d" % [minutes, seconds]
	else:
		time_label.text = str(time_remaining)
