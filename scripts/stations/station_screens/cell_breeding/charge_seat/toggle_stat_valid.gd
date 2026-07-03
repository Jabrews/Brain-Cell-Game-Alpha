extends Node

# components
@onready var valid_label : Label =$"../StatDisplay/Validity/Valid"
@onready var invalid_label : Label =$"../StatDisplay/Validity/Invalid"


func _verify_stat_valid(selected_stat : String) -> bool:
	if selected_stat == "none":
		toggle_validty_label('none')
		return false
		
	var selected_cell: BrainCell = get_parent().parent_charge_seat.selected_brain_cell
	var selected_cell_stat : BrainCellStat = selected_cell.get(selected_stat)
	
	if selected_cell_stat.enabled == false:
		get_parent().parent_charge_seat.audio_manager.play_invalid_stat()
		toggle_validty_label('invalid')
		return false
	
	if selected_cell_stat.hidden == true:
		get_parent().parent_charge_seat.audio_manager.play_invalid_stat()
		toggle_validty_label('invalid')
		return false
	
	toggle_validty_label('valid')
	
	return true

func toggle_validty_label(type : String) :
	match type : 
		'valid' :
			valid_label.visible = true
			invalid_label.visible = false
		'invalid' : 	
			valid_label.visible = false 
			invalid_label.visible = true 
		'none' :
			valid_label.visible = false 
			invalid_label.visible = false 
	
