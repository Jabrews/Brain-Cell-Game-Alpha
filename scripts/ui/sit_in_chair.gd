extends Label 


func _ready() -> void:
	GLChairBus.connect('toggle_player_entered_interpreter_chair_area', _handle_toggle_player_entered_chair_area)
	GLChairBus.connect('toggle_player_sat_on_interpreter_chair', _handle_toggle_player_sat_on_chair)


func _handle_toggle_player_entered_chair_area(toggle_value : bool) :
	if toggle_value :
		visible = true		
	else :
		visible = false
		
func _handle_toggle_player_sat_on_chair(toggle_value : bool, _interpreter_type) :
	if toggle_value : 
		visible = false 
	else :
		visible = true
