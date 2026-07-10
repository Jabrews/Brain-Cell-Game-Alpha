extends Node

@onready var pick_num_label : Label = $PickNum
@onready var out_of_prisoners_label: Label = $OutOfPrisoners


func _ready() -> void:
	GLGameManagerBus.connect('proceed_next_round', _handle_next_round)


func _update() :
	
	if GLPrisonerPicks.prisoners_to_pick <= 0 :
		out_of_prisoners_label.visible = true
		pick_num_label.visible = false
	else :
		out_of_prisoners_label.visible = false
		pick_num_label.visible = true
		pick_num_label.text = str(GLPrisonerPicks.prisoners_to_pick)


func _handle_next_round() :
	out_of_prisoners_label.visible = true
	pick_num_label.visible = false
