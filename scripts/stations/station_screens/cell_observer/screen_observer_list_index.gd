extends Node

# componnets 
@onready var curr_label : Label = $CurrLabel
@onready var max_label : Label = $MaxLabel

func update_list_max(observed_list : Array[BrainCell]) :
	var list_len = len(observed_list)
	max_label.text = str(list_len)

func update_list_curr(curr_index :int) :
	curr_index += 1 # fix index
	curr_label.text = str(curr_index)




	
	
