extends Node

# component controllers
@onready var component_controllers : Node = $ComponentControllers
@onready var toggle_doors_open : Node = $ComponentControllers/ToggleDoorsOpen
@onready var toggle_pole_exspand : Node = $ComponentControllers/TogglePoleExspand
@onready var toggle_tablet_pole_follow : Node = $ComponentControllers/ToggleTabletPoleFollow

func _start_cinnamatic() :
	
	await get_tree().create_timer(component_controllers.DOOR_OPEN_BEFORE_DELAY ).timeout
	
	toggle_doors_open._toggle(true)
	
	await get_tree().create_timer(component_controllers.DOOR_OPEN_AFTER_DELAY + component_controllers.DOOR_OPEN_DURATION ).timeout
	
	toggle_doors_open._toggle(false)
	
	
	
	
	



func _end_cinnamatic() :
	pass
