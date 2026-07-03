extends Node

var active_stat_index: int = -1

# reversed display order
var stats: Array[String] = [
	"community",
	"intelligence",
	"strength"
]

@onready var stat_highlights: Array[Sprite2D] = [
	$"../StatDisplay/Highlights/CommunityHighlight",
	$"../StatDisplay/Highlights/IntelligenceHighlight",
	$"../StatDisplay/Highlights/StrengthHighlight",
]


func _handle_cycle_stat(direction: String) -> String:
	var new_active_stat_index: int = active_stat_index
	
	if active_stat_index == -1:
		match direction:
			"up":
				new_active_stat_index = 0
			"down":
				new_active_stat_index = stats.size() - 1
			_:
				return "none"
	else:
		var direction_increment: int = 0
		
		match direction:
			"up":
				direction_increment = 1
			"down":
				direction_increment = -1
			_:
				return "none"
		
		new_active_stat_index = active_stat_index + direction_increment
		
		if new_active_stat_index >= stats.size():
			new_active_stat_index = -1
		elif new_active_stat_index < 0:
			new_active_stat_index = -1
	
	active_stat_index = new_active_stat_index
	
	return load_active_stat()


func load_active_stat() -> String:
	hide_highlights()
	
	if active_stat_index == -1:
		return "none"
	
	stat_highlights[active_stat_index].visible = true
	return stats[active_stat_index]


func hide_highlights() -> void:
	for stat_highlight: Sprite2D in stat_highlights:
		stat_highlight.visible = false


func reset_selected_stat() -> void:
	active_stat_index = -1
	hide_highlights()


func _reset_cell_removed() -> void:
	reset_selected_stat()
