extends Node

# components cam
@onready var camera : Camera3D = $Camera3D
@onready var start_point : Node3D = $StartPoint
@onready var end_point : Node3D = $EndPoint
# components sounds
#@onready var s_electric_discharge : AudioStreamPlayer3D = $Audios/ElectricDischarge
@onready var s_whoosh : AudioStreamPlayer3D = $Audios/WhooshSound
@onready var s_circuits : AudioStreamPlayer3D = $Audios/Circuts


func _ready() -> void:
	GLCinnamaticBus.connect('toggle_energy_cinnamatic', _handle_toggle_energy_cinnamatic)

func _handle_toggle_energy_cinnamatic(toggle_value : bool) : 
	
	toggle_display_lock(toggle_value)
	camera.global_position = start_point.global_position
	camera.current = toggle_value	
	GLPlayerState.emit_signal('lock_player_position', toggle_value)
	
	if toggle_value : 
		var movement_tween : Tween = create_tween()	
		movement_tween.tween_property(camera, 'global_position', end_point.global_position,  0.7)
		
		s_whoosh.play()
		s_circuits.play()
		
		# start particles
		await get_tree().create_timer(1.0).timeout		
		
		# end cinnamatic
		await get_tree().create_timer(2.0).timeout		
		
		s_circuits.stop()
		
		GLCinnamaticBus.emit_signal('toggle_energy_cinnamatic', false)
		

func toggle_display_lock(toggle_value: bool) -> void:
	
	if toggle_value:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true

	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		
	
	
	
	
	
	
	
	
	
