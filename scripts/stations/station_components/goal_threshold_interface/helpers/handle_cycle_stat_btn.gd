extends Node

# components
@onready var selected_stat_screens : Array[Node2D] = [
	$"../CellSeats/SelectedStatTvs/SelectedStatTV1/TvFrontPannel/SubViewport/ScreenSelectedStat",
	$"../CellSeats/SelectedStatTvs/SelectedStatTV2/TvFrontPannel/SubViewport/ScreenSelectedStat",
	$"../CellSeats/SelectedStatTvs/SelectedStatTV3/TvFrontPannel/SubViewport/ScreenSelectedStat",
	$"../CellSeats/SelectedStatTvs/SelectedStatTV4/TvFrontPannel/SubViewport/ScreenSelectedStat",
]

var cell_selected_stats : Dictionary[int, String] = {
	1 : "off",
	2 : "off",
	3 : "off",
	4 : "off",
}

var stat_cycle : Array[String] = [
	"none",
	"all",
	"strength",
	"intelligence",
	"community",
]


func _toggle_cell_added(toggle_value : bool, cell_seat_num : int) -> void:
	
	var new_state : String = "none" if toggle_value else "off"
	
	cell_selected_stats[cell_seat_num] = new_state
	# toggle screen
	selected_stat_screens[cell_seat_num - 1]._toggle_display(new_state)


func _handle(direction : String, cell_seat_num : int) -> void:
	
	var current_selected_stat : String = cell_selected_stats[cell_seat_num]
	
	if current_selected_stat == "off":
		GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
		return
	
	var direction_increment : int
	
	match direction:
		"up":
			direction_increment = 1
		"down":
			direction_increment = -1
		_:
			push_error("bad direction: ", direction)
			return
	
	var curr_cycle_index : int = stat_cycle.find(current_selected_stat)
	
	if curr_cycle_index == -1:
		push_error("could not find stat/state inside stat cycle: ", current_selected_stat)
		return
	
	GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_success")
	
	# wrap around cycle
	var next_cycle_index : int = wrapi(
		curr_cycle_index + direction_increment,
		0,
		stat_cycle.size()
	)
	
	var next_selected_stat : String = stat_cycle[next_cycle_index]
	
	cell_selected_stats[cell_seat_num] = next_selected_stat
	
	# toggle screen
	selected_stat_screens[cell_seat_num - 1]._toggle_display(next_selected_stat)
