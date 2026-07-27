extends Node


var particle_text: Array[String] = [
	'1', '0'
]

# Components
@onready var particle_labels: Array[Label3D] = [
	$Particle1,
	$Particle2,
	$Particle3,
	$Particle4,
	$Particle5,
]

@onready var kill_timer: Timer = $KillTimer
@onready var change_particle_timer: Timer = $ChangeParticleTimer


func _ready() -> void:
	kill_timer.timeout.connect(
		_handle_kill_timer_timeout
	)

	change_particle_timer.timeout.connect(
		_handle_change_particle_timer_timeout
	)

	refresh_particles()

	kill_timer.start()
	change_particle_timer.start()


func _handle_kill_timer_timeout() -> void:
	change_particle_timer.stop()

	var opacity_tween: Tween = create_tween()
	opacity_tween.set_parallel(true)

	for particle_label: Label3D in particle_labels:
		opacity_tween.tween_property(
			particle_label,
			"modulate:a",
			0.0,
			0.5
		)

	await opacity_tween.finished

	queue_free()


func _handle_change_particle_timer_timeout() -> void:
	refresh_particles()


func refresh_particles() -> void:
	# Reset every label before selecting the black ones.
	for particle_label: Label3D in particle_labels:
		particle_label.text = particle_text.pick_random()
		particle_label.modulate = Color.DARK_GREEN

	# Shuffle a duplicate so two unique labels are selected.
	var shuffled_labels: Array[Label3D] = particle_labels.duplicate()
	shuffled_labels.shuffle()

	shuffled_labels[0].modulate = Color.BLACK
	shuffled_labels[1].modulate = Color.BLACK
