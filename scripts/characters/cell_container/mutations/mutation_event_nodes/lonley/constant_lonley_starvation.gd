extends MutationNode


# Helper component
@onready var face_sprite_manager: Node = $FaceSpriteManager

# Component timers
@onready var start_delay_timer: Timer = $StartDelayTimer
@onready var check_for_other_cells_timer: Timer = $CheckForOtherCellsTimer
@onready var cry_delay_timer: Timer = $CryDelayTimer

# Other components
@onready var detect_other_cells_area: Area3D = $DetectOtherCellArea
@onready var face_sprite : Sprite3D = $FaceSpriteManager/FaceSprite

# Audio components
@onready var face_entry_sounds: Array[AudioStreamPlayer3D] = [
	$SmileStartSound,
	$FrownStartSound,
	$CryStartSound,
]

# cry particle
@onready var cry_particle :GPUParticles3D = $CryParticle


var current_face_type: String = "smile"
var is_lonely: bool = false
var cry_active: bool = false

@export var hide_distance: float = 2.7


func _process(_delta: float) -> void:
	var player: Node3D = GLPlayerState.player_refrence

	if player == null:
		return

	var distance_to_player: float = global_position.distance_to(
		player.global_position
	)

	if distance_to_player <= hide_distance:
		face_sprite.modulate.a = 0.05
	else:
		face_sprite.modulate.a = 1.0


func _ready_overide() -> void:
	stop_on_pickup = false
	random_event = false

	cry_delay_timer.one_shot = true

	check_for_other_cells_timer.timeout.connect(
		_handle_check_for_other_cells_timer_timeout
	)

	cry_delay_timer.timeout.connect(
		_handle_cry_delay_timeout
	)


func _start() -> void:
	
	unhide_mutation()
	
	is_lonely = false
	cry_active = false

	switch_current_face_type("smile")

	start_delay_timer.start()
	await start_delay_timer.timeout

	check_for_other_cells_timer.start()


func switch_current_face_type(new_face_type: String) -> void:
	
	var skip_entry_sound : bool = false	
		
	
	if new_face_type == current_face_type:
		return
	
	if new_face_type == 'frown' and current_face_type == 'cry' :
		skip_entry_sound = true
	
	if new_face_type == 'cry' :
		cry_particle.emitting = true 
	else :
		cry_particle.emitting = false 
		
		
				

	current_face_type = new_face_type

	face_sprite_manager.switch_icon(new_face_type)
	
	if not skip_entry_sound : 
		play_entry_sound()


func play_entry_sound() -> void:
	for entry_sound: AudioStreamPlayer3D in face_entry_sounds:
		entry_sound.stop()
	

	match current_face_type:
		"smile":
			face_entry_sounds[0].play()

		"frown":
			face_entry_sounds[1].play()

		"cry":
			face_entry_sounds[2].play()


func _handle_check_for_other_cells_timer_timeout() -> void:
	var other_cell_found: bool = await (
		detect_other_cells_area.flash_check_for_other_cell()
	)

	if other_cell_found:
		is_lonely = false
		cry_active = false

		cry_delay_timer.stop()
		switch_current_face_type("smile")
		return

	is_lonely = true

	# Do not interrupt the brief crying period.
	if cry_active:
		return

	switch_current_face_type("frown")

	# Begin the delay before the next cry.
	if cry_delay_timer.is_stopped():
		cry_delay_timer.start()


func _handle_cry_delay_timeout() -> void:
	if not is_lonely:
		return

	if current_face_type != "frown":
		return
	
	
	GLCellManagerBus.emit_signal('mutation_frowny_increase_defect', parent_cell_container.designated_brain_cell)
	

	cry_active = true
	switch_current_face_type("cry")

	await get_tree().create_timer(2.2).timeout

	cry_active = false

	# Another cell may have entered while it was crying.
	if not is_lonely:
		return

	switch_current_face_type("frown")

	# Start another delayed cry cycle while still lonely.
	cry_delay_timer.start()


func _stop() -> void:
	is_lonely = false
	cry_active = false

	start_delay_timer.stop()
	check_for_other_cells_timer.stop()
	cry_delay_timer.stop()

	for entry_sound: AudioStreamPlayer3D in face_entry_sounds:
		entry_sound.stop()
