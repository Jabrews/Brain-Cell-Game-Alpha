extends Node

# higlight sprites
@onready var active_stat_highlights : Array[Sprite2D] = [
	$"../../StatDisplay/Highlights/CommunityHighlight",
	$"../../StatDisplay/Highlights/IntelligenceHighlight",
	$"../../StatDisplay/Highlights/StrengthHighlight",
]
# validty components
@onready var stat_valid_label : Label = $"../../StatDisplay/Validity/Valid"
@onready var stat_invalid_label : Label = $"../../StatDisplay/Validity/Invalid"

# helper cycled_stat_debuff
@onready var preview_cycled_stat_debuff : Node = $PreviewCycledStatDebuff



func _handle_recieve_cycled(cycled_index : int, cycled_stat : String) :
	
	reset_active_stat_highlights() 
	
	# if cycled index is acutall stat
	if cycled_index != -1  :
		
		# set highlight
		active_stat_highlights[cycled_index].visible = true		
		
		var stat_isnt_none = cycled_stat != 'none'
		stat_valid_label.visible = stat_isnt_none
		stat_invalid_label.visible = !stat_isnt_none
		
		
		if stat_isnt_none :
			preview_cycled_stat_debuff._handle_preview_debuff(cycled_stat)

	# else it is -1. therefore no stat selected
	else : 
		stat_valid_label.visible = false
		stat_invalid_label.visible = false
			
		
		
	
func reset_active_stat_highlights() :
	for active_highlight : Sprite2D in active_stat_highlights : 
		active_highlight.visible = false
	
	
	
	
