extends Node

# components
@onready var pick_num_left_label : Label = $PickNum

func _ready() -> void:
	pick_num_left_label.text = '0'
	
func _update(prisoner_quanity : int) :
	GLPrisonerPicksBus.next_max_picked_pris_per_turn = prisoner_quanity 
	
	pick_num_left_label.text = str(prisoner_quanity)
		

func _create() :
	GLPrisonerPicksBus.curr_picked_pris_per_turn = GLPrisonerPicksBus.next_max_picked_pris_per_turn
	GLPrisonerPicksBus.next_max_picked_pris_per_turn = 0
	_update(GLPrisonerPicksBus.next_max_picked_pris_per_turn)
	
	
	
	
