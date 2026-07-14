extends Node

# display componnets
@onready var parent_active : Control = $Active
@onready var parent_inactive : Control = $Inactive
@onready var parent_used_up : Control = $UsedUp

func switch_screen(type : String) :
	
	toggle_displays_off()	
	
	match type : 
		'active' :
			parent_active.visible = true
		'inactive' :
			parent_inactive.visible = true
		'used' :
			parent_used_up.visible = true

func toggle_displays_off() :
	parent_active.visible = false
	parent_inactive.visible = false
	parent_used_up.visible = false
