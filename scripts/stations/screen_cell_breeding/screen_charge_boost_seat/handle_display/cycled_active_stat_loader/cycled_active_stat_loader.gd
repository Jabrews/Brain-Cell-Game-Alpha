extends Node

@onready var active_stat_highlights : Array[Sprite2D] = [
	$"../../StatDisplay/Highlights/StrengthHighlight",
	$"../../StatDisplay/Highlights/IntelligenceHighlight",
	$"../../StatDisplay/Highlights/CommunityHighlight"
]
@onready var stat_valid_label : Label = $"../../StatDisplay/Validity/Valid"
@onready var stat_invalid_label : Label = $"../../StatDisplay/Validity/Invalid"

func _handle_recieve_cycled(cycled_index : int, cycled_stat : String) :
	
	reset_active_stat_highlights() 
	
	# if cycled index is acutall stat
	if cycled_index != -1  :
		
		# set highlight
		active_stat_highlights[cycled_index].visible = true		
		
		var stat_isnt_none = cycled_stat != 'none'
		stat_valid_label = stat_isnt_none
		stat_invalid_label = !stat_isnt_none

	# else it is -1. therefore no stat selected
	else : 
			
		
		
	
func reset_active_stat_highlights() :
	for active_highlight : Sprite2D in active_stat_highlights : 
		active_highlight.visible = false
	
	
	
	
