extends Node

@onready var drop_axe_parent : Control = $DropAxeBackAtMount
@onready var pickup_axe_parent : Control = $PickupAxeFromMount
@onready var return_axe_parent : Control = $PressToReturn

var player_has_axe : bool = false
var player_looking_at_axe_mount : bool = false


func _ready() -> void:
	GLPlayerState.connect(
		"toggle_player_picked_up_axe_mount",
		_handle_toggle_player_picked_up_axe_mount
	)
	
	GLPlayerState.connect(
		"toggle_player_looking_at_axe_mount",
		_handle_toggle_player_looking_at_axe_mount
	)
	
	_update_display()


func _handle_toggle_player_picked_up_axe_mount(toggle_value : bool) -> void:
	player_has_axe = toggle_value
	_update_display()


func _handle_toggle_player_looking_at_axe_mount(toggle_value : bool) -> void:
	player_looking_at_axe_mount = toggle_value
	_update_display()


func _update_display() -> void:
	# Hide everything first
	drop_axe_parent.visible = false
	pickup_axe_parent.visible = false
	return_axe_parent.visible = false
	
	
	if player_has_axe:
		
		if player_looking_at_axe_mount:
			# Looking at mount while holding axe
			drop_axe_parent.visible = true
		else:
			# Holding axe, but not looking at mount
			return_axe_parent.visible = true
	
	else:
		
		if player_looking_at_axe_mount:
			# Axe is still mounted and player is looking at it
			pickup_axe_parent.visible = true
