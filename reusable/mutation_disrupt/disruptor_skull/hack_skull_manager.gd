extends Node

@onready var detect_skull_areas : Array[Area2D] = [
	$DetectSkullAreas/Top, $DetectSkullAreas/Bottom, $DetectSkullAreas/Left, $DetectSkullAreas/Right
]
@onready var hack_skull : CharacterBody2D = $HackSkull

func _start_hack_skull() :
	
	hack_skull._start()
	
	for detect_area : Area2D in detect_skull_areas :	
		detect_area.monitoring = true
	

func _stop_hack_skull() :
	
	hack_skull._stop()
	
	for detect_area : Area2D in detect_skull_areas :	
		detect_area.monitoring = false 
