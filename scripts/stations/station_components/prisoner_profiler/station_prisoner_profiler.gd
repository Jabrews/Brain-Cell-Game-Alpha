extends Node

var clean_strength : float = 0.0
var clean_intelligence: float = 0.0
var clean_community : float = 0.0
var strength_disabled : bool = false
var intelligence_disabled : bool = false
var community_disabled : bool = false

# components
@onready var help_convert_clean_range : Node = $HelpConvertCleanRange
@onready var help_convert_addition_value : Node = $HelpConvertAdditionValue


func _update_clean_stat_value(type : String, clean_range : String, stat_addition : float) :
	
	var clean_value : float = 0.0	
	
	# get clean range value : 'low' -> 200
	var clean_range_value = help_convert_clean_range._handle_help_convert_clean_range(clean_range)
	clean_value += clean_range_value
	# get addition value '+1' -> +20
	var addition_value = help_convert_addition_value._handle_help_convert_addition_value(clean_range, stat_addition)
	clean_value += addition_value 
	
	
	match type :	
		'strength' :
			clean_strength = clean_value
		'intelligence' :
			clean_intelligence = clean_value
		'community' :
			clean_community = clean_value

			
	
	
	
