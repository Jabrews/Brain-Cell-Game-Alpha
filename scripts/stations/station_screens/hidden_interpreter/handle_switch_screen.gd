extends Node

@onready var idle_screen : Control =$"../IdleScreen"
@onready var no_cell_detected_screen : Control  = $"../NoCellDetected"
@onready var no_hidden_stat_detected_screen : Control  =$"../NoHiddenStatDetected"
@onready var jolt_detected_screen : Control = $"../JoltDetectedPleaseReset"
@onready var finished_screen : Control = $"../Finished"


func _switch(screen_type : String, info_screen_type) :
	
	toggle_all_screens_off()	
	
	if screen_type == 'INFO_SCREEN' :
		
		match info_screen_type :
			'NO_CELL_DETECTED' :
				no_cell_detected_screen.visible = true
			'INVALID_STAT' :
				no_hidden_stat_detected_screen.visible = true
			'JOLT' :
				jolt_detected_screen.visible = true
			'FINISHED' :
				finished_screen.visible = true
		
	if screen_type == 'IDLE_SCREEN':	
		idle_screen.visible = true
	
	if screen_type == 'GAME_SCREEN' :
		pass
	
func toggle_all_screens_off() :
	idle_screen.visible = false
	no_cell_detected_screen.visible = false
	no_hidden_stat_detected_screen.visible = false
	jolt_detected_screen.visible = false
	finished_screen.visible = false
