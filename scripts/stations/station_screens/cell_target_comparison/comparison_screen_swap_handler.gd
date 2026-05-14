extends Node

# componnets
@onready var target_stat_display_parent : Control = $"../../TargetStatDisplay"
@onready var compare_screen_parent : Control = $"../../CompareScreen"
@onready var failed_label : Label = $"../../CompareScreen/Failed"
@onready var passed_label : Label = $"../../CompareScreen/Passed"


func _ready() -> void:
	swap_screen('target_stat_display')

func swap_screen(screen_name : String) : 
	hide_all_screens()	
	
	match screen_name :
		'target_stat_display' :
			target_stat_display_parent.visible = true
		'compare_passed' :
			compare_screen_parent.visible = true
			passed_label.visible = true
		'compare_failed' :
			compare_screen_parent.visible = true
			failed_label.visible = true
		
		
		
	

func hide_all_screens() :
	target_stat_display_parent.visible = false
	compare_screen_parent.visible = false
	passed_label.visible = false
	failed_label.visible = false
