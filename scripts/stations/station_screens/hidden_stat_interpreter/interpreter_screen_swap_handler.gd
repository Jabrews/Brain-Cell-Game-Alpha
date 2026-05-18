extends Node

# componnets
@onready var interpreter_screen : Control = $"../InterpreterScreen"
@onready var no_cell_detected_screen : Control = $"../NoCellDetected"
@onready var no_hidden_stat_detected_screen : Control = $"../NoHiddenStatDetected"
@onready var jolt_detected_screen : Control = $"../JoltDetectedPleaseReset"


func _ready() -> void:
	swap_screen('no_cell')

func swap_screen(screen_name : String) : 
	hide_all_screens()	
	
	match screen_name :
		'interpreter' :
			interpreter_screen.visible = true
		'no_cell' :
			no_cell_detected_screen.visible = true	
		'no_hidden' :
			no_hidden_stat_detected_screen.visible = true
		'jolt_detected' :
			jolt_detected_screen.visible = true
		
		
		
	

func hide_all_screens() :
	interpreter_screen.visible = false
	no_cell_detected_screen.visible = false
	no_hidden_stat_detected_screen.visible = false
	jolt_detected_screen.visible = false	
