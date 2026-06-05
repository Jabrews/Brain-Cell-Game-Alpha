extends Node

@onready var pick_num_label : Label = $PickNum
@onready var out_of_prisoners_label: Label = $OutOfPrisoners

func _ready() -> void:
	#GLCellManagerBus.connect('prisoner_picked_by_player', _handle_prisoner_picked_by_player)
	GLPrisonerPicksBus.connect('current_max_generated', _handle_curr_max_generated)

func _handle_curr_max_generated() :
	
	pick_num_label.visible = true
	out_of_prisoners_label.visible = false
	
	var max_pris_picked = GLPrisonerPicksBus.max_picked_pris_per_turn	
	pick_num_label.text = str(max_pris_picked)

func _update_out_of_prisoners() :
	out_of_prisoners_label.visible = true
	pick_num_label.visible = false

func _update_new_pick_quanity() :
	
	pick_num_label.visible = true
	out_of_prisoners_label.visible = false
	
	var pris_picked = GLPrisonerPicksBus.max_picked_pris_per_turn - GLPrisonerPicksBus.curr_picked_pris_per_turn
	pick_num_label.text = str(pris_picked)
