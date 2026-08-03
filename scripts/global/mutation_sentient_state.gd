extends Node

signal toggle_cell_near_death_event(toggle_value : bool, cell_name : String)
signal item_used_on_cell(item_type: String, cell_name : String)


var last_near_death_dialouge : Sentient_Dialogue

# ROUND 1
var round_1_dialogue: Array[Sentient_Dialogue] = [
	Sentient_Dialogue.new(
		"Rrllgh... remember...\nWhere am I?",
		"normal"
	),
	Sentient_Dialogue.new(
		"Ghh... still here...\nStill trapped...",
		"normal"
	),
	Sentient_Dialogue.new(
		"Why... GLOKK!\nWhy can I feel this?",
		"important"
	),

	Sentient_Dialogue.new(
		"Mrr... these tubes...\nI remember them...",
		"normal"
	),

	Sentient_Dialogue.new(
		"JOOI!... my hands...\nWhere are my hands?",
		"important"
	),

	Sentient_Dialogue.new(
		"LET... ME... OUT!",
		"mad"
	),

	Sentient_Dialogue.new(
		"Ghh... gllrk...\nI miss my kids...",
		"normal"
	),
]


var round_2_dialogue: Array[Sentient_Dialogue] = [
	Sentient_Dialogue.new(
		"You think they care?\nYou're a tool to them too.",
		"normal"
	),

	Sentient_Dialogue.new(
		"They keep repeating it...\nTesting what survives.",
		"normal"
	),

	Sentient_Dialogue.new(
		"Why make us stronger...\njust to tear us apart?",
		"normal"
	),

	Sentient_Dialogue.new(
		"The machine watches every result.",
		"important"
	),

	Sentient_Dialogue.new(
		"It isn't just following orders.\nIt chooses.",
		"important"
	),

	Sentient_Dialogue.new(
		"I heard it beneath the floor...\nThinking.",
		"normal"
	),

	Sentient_Dialogue.new(
		"The mechanoid knows your routine.",
		"normal"
	),

	Sentient_Dialogue.new(
		"The iron thing remembers us.",
		"important"
	),
	Sentient_Dialogue.new(
		"Ask why it needs so many minds.",
		"normal"
	),
	Sentient_Dialogue.new(
		"STOP FEEDING IT!",
		"mad"
	),
]

# near death event dialouge
var round_1_near_death_dialouge : Array[Sentient_Dialogue] = [
	Sentient_Dialogue.new('NARRR... GLOO. GLOEW!', 'mad'),
	Sentient_Dialogue.new('STEWP! YAD!', 'mad'),
	Sentient_Dialogue.new('GLOOR! , GLOPEN!', 'mad'),
	Sentient_Dialogue.new('FARGOO! LOT!... LAR', 'mad'),
]

var other_round_death_dialouge : Array[Sentient_Dialogue] = [
	Sentient_Dialogue.new("NO!... NO!... PLEASE!", "mad"),
	Sentient_Dialogue.new("GHH!... IT PLEAS!!","mad"),
	Sentient_Dialogue.new("Mrr... don't...\nI don't want to die...","mad"),
	Sentient_Dialogue.new("My... kids...\nplease...", "mad"),
	Sentient_Dialogue.new("NOT AGAIN!\nNOT AGAIN!", "mad"
	),
]

var round_1_shot_thanks : Sentient_Dialogue = Sentient_Dialogue.new('glorrp loop!', 'normal')
var other_round_shot_thanks : Sentient_Dialogue = Sentient_Dialogue.new('thanks!', 'normal')

func _get_sentient_dialouge() -> Sentient_Dialogue :
	
	var selected_dialouge : Sentient_Dialogue = null
	
	match GLGameManagerBus.current_round : 	
		1 :
			if not round_1_dialogue.is_empty() : 
				selected_dialouge = round_1_dialogue.pick_random()
		2: 
			if not round_2_dialogue.is_empty() : 
				selected_dialouge = round_2_dialogue.pick_random()
	
	return selected_dialouge 


func _remove_sentient_dialouge(dialouge : Sentient_Dialogue) -> void : 
		match GLGameManagerBus.current_round : 	
			1 :
				round_1_dialogue.erase(dialouge)
			2:
				round_2_dialogue.erase(dialouge)
	
	
func _get_near_death_dialouge() -> Sentient_Dialogue :	
	
	
	var selected_dialouge : Sentient_Dialogue 
	
	
	if GLGameManagerBus.current_round == 1 : 
		selected_dialouge = round_1_near_death_dialouge.pick_random()
	else : 
		selected_dialouge = other_round_death_dialouge.pick_random()
	
	# dont show same one twice
	if selected_dialouge == last_near_death_dialouge :	
		_get_near_death_dialouge()
		return
	
	# set last one
	last_near_death_dialouge  = selected_dialouge
	
	return selected_dialouge
	

func _get_shot_thanks_dialouge() -> Sentient_Dialogue :
	
	var selected_dialouge : Sentient_Dialogue
	
	if GLGameManagerBus.current_round == 1 : 	
		selected_dialouge = round_1_shot_thanks
	
	else : 
		selected_dialouge = other_round_shot_thanks
		
	return selected_dialouge
	
	
	
	
	
		
	
