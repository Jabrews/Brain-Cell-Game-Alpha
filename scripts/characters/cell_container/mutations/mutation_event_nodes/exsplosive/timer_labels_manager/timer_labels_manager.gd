extends Node


# omponent labels
@onready var header_time_left_label: Label3D = $HeaderTimeLeft
@onready var min_seconds_label: Label3D = $MinSeconds

# visuals manager 
@onready var label_visuals_manager : Node = $LabelVisualsManager


# hiding
@export var hide_distance: float = 2.5

# making label lower opacity
func _process(_delta: float) -> void:
	var player: Node3D = GLPlayerState.player_refrence

	if player == null:
		return

	var distance_to_player: float = get_parent().parent_cell_container.global_position.distance_to(
		player.global_position
	)

	if distance_to_player <= hide_distance:
		header_time_left_label.modulate.a = 0.03
		min_seconds_label.modulate.a = 0.03
	else:
		header_time_left_label.modulate.a = 1.00
		min_seconds_label.modulate.a = 1.00
	
func _refresh_timer_labels(time_left_to_exsplode: int) -> void:
	
	label_visuals_manager._refresh_visuals(time_left_to_exsplode, get_parent().max_time_before_expslode)
	
	@warning_ignore("integer_division")
	var minitues: int = time_left_to_exsplode / 60
	var seconds: int = time_left_to_exsplode - (minitues * 60)

	display_min_seconds_left(
		minitues,
		seconds
	)


func display_min_seconds_left(
	minitues: int,
	seconds: int
) -> void:
	if minitues != 0:
		if seconds < 10 : 
			# adding a 0 infront
			min_seconds_label.text = str(minitues) + " -0" + str(seconds)
		else : 
			min_seconds_label.text = str(minitues) + " -" + str(seconds)

	else:
		if seconds < 10 : 
			min_seconds_label.text = '0' + str(seconds)
		else : 
			min_seconds_label.text = str(seconds)
