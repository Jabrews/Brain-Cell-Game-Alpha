extends Node

# component controllers
@onready var component_controllers : Node = $ComponentControllers
@onready var toggle_doors_open : Node = $ComponentControllers/ToggleDoorsOpen
@onready var toggle_pole_exspand : Node = $ComponentControllers/TogglePoleExspand
@onready var toggle_tablet_pole_follow : Node = $ComponentControllers/ToggleTabletPoleFollow

func _start_cinnamatic() :
	
	GLHideUiBus.emit_signal("toggle_hide_ui", true)
	GLPlayerState.emit_signal('toggle_freeze_player', true)
	
	
	await get_tree().create_timer(component_controllers.DOOR_OPEN_BEFORE_DELAY ).timeout
	
	toggle_doors_open._toggle(true)
	
	GLCinnamaticBus.emit_signal('toggle_energy_cinnamatic', true)
	
	await get_tree().create_timer(component_controllers.DOOR_OPEN_AFTER_DELAY + component_controllers.DOOR_OPEN_DURATION ).timeout
	
	toggle_pole_exspand._toggle(true)
	
	await get_tree().create_timer(component_controllers.POLE_EXSPAND_AFTER_DELAY + component_controllers.POLE_EXSPAND_DURATION).timeout
	
	toggle_tablet_pole_follow._toggle(true)
	
	await get_tree().create_timer(0.5).timeout
	
	GLCinnamaticBus.emit_signal('toggle_energy_cinnamatic', false)
	
	GLHideUiBus.emit_signal("toggle_hide_ui", false)
	GLPlayerState.emit_signal('toggle_freeze_player', false)
	
	
	
func _end_cinnamatic() :
	
	await get_tree().create_timer(component_controllers.POLE_EXSPAND_BEFORE_DELAY).timeout
	
	toggle_pole_exspand._toggle(false)
	
	await get_tree().create_timer(component_controllers.POLE_EXSPAND_AFTER_DELAY + component_controllers.POLE_EXSPAND_DURATION).timeout
	
	toggle_doors_open._toggle(false)
	
	await get_tree().create_timer(component_controllers.DOOR_OPEN_AFTER_DELAY + component_controllers.DOOR_OPEN_DURATION ).timeout
	
	toggle_tablet_pole_follow._toggle(false)
	
