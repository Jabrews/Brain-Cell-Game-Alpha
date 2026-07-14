extends Node

@onready var spare_symbol_updater : Node = $SpareSymbolsUpdater
@onready var safe_mode_disable_spare : Node = $SafeModeDisableSpare
@onready var spare_symbol_evaluator : Node = $SpareSymbolEvaluator

var selected_spare_icon_constructors: Array[SpareIconConstuctor]
var saved_spare_icon_constructors : Array[SpareIconConstuctor]


func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect('recieve_profiler_spare_icons', _handle_recieve_profiler_spare_icons)
	

	
func _generate_spare() :
	selected_spare_icon_constructors = []
	GLPrisonerProfilerComponentsBus.emit_signal('request_new_profiler_spare_icons')

func _toggle_safe_mode_disable_spare_icons(safe_mode_active: bool) :
	
	# load prior spare icons
	if not safe_mode_active :
		# get the prior generated icon constructor
		selected_spare_icon_constructors = saved_spare_icon_constructors
		# let screen see symbols
		spare_symbol_updater._update_large_stat_screens(selected_spare_icon_constructors)
		# deal with refreshing the current position with evaluator
		spare_symbol_evaluator._refresh_safe_mode_disabled()
	if safe_mode_active :
		
		# disable any current state that gets to prisoner profiler		
		safe_mode_disable_spare._handle_disable_spare_symbols()
		
		# set selected icon constructor to none for each stat
		selected_spare_icon_constructors = [
			SpareIconConstuctor.new('strength', 'none', 'up', 0, 0),
			SpareIconConstuctor.new('intelligence', 'none', 'up', 0, 0),
			SpareIconConstuctor.new('community', 'none', 'up', 0, 0)
		]
		# let screen know no symbols
		spare_symbol_updater._update_large_stat_screens(selected_spare_icon_constructors)
		
	

func _handle_recieve_profiler_spare_icons(spare_item_constuctors: Array[SpareIconConstuctor]) :
	
	selected_spare_icon_constructors = spare_item_constuctors
	saved_spare_icon_constructors = spare_item_constuctors
	
	spare_symbol_updater._update_large_stat_screens(selected_spare_icon_constructors)



	
	
