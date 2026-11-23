extends ColorRect

@export var hint_parent : Node 

func _ready() -> void:
	connect('mouse_entered', _handle_mouse_entered)
	connect('mouse_exited', _handle_mouse_exited)
	connect('focus_entered', _handle_mouse_entered)
	connect('focus_exited', _handle_mouse_exited)
	

func _handle_mouse_entered() : 
	hint_parent.visible = true
	
func _handle_mouse_exited() : 
	hint_parent.visible = false 
