extends Node

@onready var closed : Control = $Closed
@onready var open : Control = $Open
@onready var locked : Control = $Locked

func _switch_screen(screen_type : String) : 
	
	reset()	
	
	match screen_type : 
		'closed' :
			closed.visible = true
		'open' :
			open.visible = true
		'locked' :
			locked.visible = true
		_ : 
			push_error('unable to find door button screen : ', screen_type)

func reset() :
	closed.visible = false
	open.visible = false
	locked.visible = false
