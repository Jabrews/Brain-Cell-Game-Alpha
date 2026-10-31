extends Node

var curr_defect_scraps: int = 0

signal defect_scraps_changed(new_defect_scraps: int)
signal update_ui_scraps_changed(new_defect_scraps: int, old_defect_scraps: int)


func _ready() -> void:
	defect_scraps_changed.connect(_handle_defect_scraps_changed)


#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("debug1"):
		#defect_scraps_changed.emit(curr_defect_scraps + 5)
#
	#if Input.is_action_just_pressed("debug2"):
		#defect_scraps_changed.emit(curr_defect_scraps - 5)


func _handle_defect_scraps_changed(new_defect_scraps: int) -> void:
	update_ui_scraps_changed.emit(
		new_defect_scraps,
		curr_defect_scraps
	)
	curr_defect_scraps = new_defect_scraps
