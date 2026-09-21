extends Node

# components
@onready var get_side_boost_components : Node = $"../GetSideBoostComponents"
@onready var parent_station : Node3D = $"../.."


func _toggle_available(side : String, toggle_value : bool) :
	
	var boost_components : Dictionary = get_side_boost_components._get_boost(side)
	
	var up_charge_direction_btn = boost_components["up_charge_direction_btn"]
	var down_charge_direction_btn = boost_components["down_charge_direction_btn"]
	
	if toggle_value :
		up_charge_direction_btn._toggle_available(true)
		down_charge_direction_btn._toggle_available(true)
	else :
		up_charge_direction_btn._toggle_available(false)
		down_charge_direction_btn._toggle_available(false)
		
		up_charge_direction_btn.selected = false
		down_charge_direction_btn.selected = false
		
		parent_station.set_boost_direction(side, "none")


func _toggle_btn_pressed(side : String, btn_direction : String) :
	
	var boost_components : Dictionary = get_side_boost_components._get_boost(side)
	
	var up_charge_direction_btn = boost_components["up_charge_direction_btn"]
	var down_charge_direction_btn = boost_components["down_charge_direction_btn"]
	var up_charge_direction_highlight = boost_components["up_charge_direction_btn_highlight"]
	var down_charge_direction_highlight = boost_components["down_charge_direction_btn_highlight"]
	
	
	# get clicked button
	var selected_btn
	var selected_highlight
	
	if btn_direction == "up":
		selected_btn = up_charge_direction_btn
		selected_highlight = up_charge_direction_highlight
	
	elif btn_direction == "down":
		selected_btn = down_charge_direction_btn
		selected_highlight = down_charge_direction_highlight
	
	else:
		push_error("Invalid boost direction: ", btn_direction)
		return
	
	
	# remember if this was already selected
	var was_selected : bool = selected_btn.selected
	
	
	# reset both first
	up_charge_direction_btn.selected = false
	down_charge_direction_btn.selected = false
	
	up_charge_direction_highlight.visible = false
	down_charge_direction_highlight.visible = false
	
	up_charge_direction_highlight.modulate.a = 0.5
	down_charge_direction_highlight.modulate.a = 0.5
	
	
	# clicked already selected -> unselect
	if was_selected:
		parent_station.set_boost_direction(side, "none")
		return
	
	
	# select new direction
	selected_btn.selected = true
	selected_highlight.visible = true
	selected_highlight.modulate.a = 1.0
	
	
	# communicate back to parent
	parent_station.set_boost_direction(side, btn_direction)
