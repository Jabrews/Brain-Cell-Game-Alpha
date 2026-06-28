extends Node

@onready var pick_num_label : Label = $PickNum
@onready var out_of_prisoners_label: Label = $OutOfPrisoners

func _update() :
	
	if GLPrisonerPicksBus.curr_picked_pris_per_turn <= 0 :
		out_of_prisoners_label.visible = true
		pick_num_label.visible = false
	else :
		out_of_prisoners_label.visible = false
		pick_num_label.visible = true
		pick_num_label.text = str(GLPrisonerPicksBus.curr_picked_pris_per_turn)
