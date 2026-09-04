extends Node

# component displays
@onready var off : Control = $Displays/Off
@onready var strength : Control = $Displays/Strength
@onready var intelligence: Control = $Displays/Intelligence
@onready var community : Control = $Displays/Community
@onready var all : Control = $Displays/All
@onready var none : Control = $Displays/None



func _toggle_display(type : String) :
	
	reset()
	
	match type : 	
		'off' :
			off.visible = true
		'strength' :
			strength.visible = true
		'intelligence' :
			intelligence.visible = true
		'community' :
			community.visible = true
		'all' :
			all.visible = true
		'none' :
			none.visible = true
	
func reset() :
	off.visible = false
	strength.visible = false
	intelligence.visible = false
	community.visible = false
	all.visible = false
	none.visible = false
