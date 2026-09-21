extends Node

# components
@onready var get_side_boost_components : Node = $"../GetSideBoostComponents"

# component labels
@onready var valid_label : Label 
@onready var invalid_label : Label 
@onready var none_label : Label 

func _display_type(side : String, type : String): 
	
	var boost_components : Dictionary = get_side_boost_components._get_boost(side)
	
	valid_label = boost_components['valid_label']
	invalid_label = boost_components['invalid_label']
	none_label = boost_components['none_label']
	
	valid_label.visible = false
	invalid_label.visible = false
	none_label.visible = false
	
	match type : 
		'valid' : 
			valid_label.visible = true
		'invalid' :
			invalid_label.visible = true
		'none' :
			none_label.visible = true
