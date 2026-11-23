extends Node


# Components
@onready var matrix_particle_scene: PackedScene = preload(
	"res://scenes/characters/cell_container/mutations/mutation_event_nodes/disruptor/matrix_particle.tscn"
)

@onready var particle_spawn_points: Array[Node3D] = [
	$"ParticleSpawnPoints/1",
	$"ParticleSpawnPoints/2",
	$"ParticleSpawnPoints/3",
	$"ParticleSpawnPoints/4",
	$"ParticleSpawnPoints/5",
	$"ParticleSpawnPoints/6",
	$"ParticleSpawnPoints/7",
	$"ParticleSpawnPoints/8",
]

@onready var particle_parent_node: Node3D = $ParticlesParentNode
@onready var new_particles_delay_timer: Timer = $NewParticlesDelayTimer
@onready var binary_beep_sound : AudioStreamPlayer3D = $"../Sounds/BinaryBeepSound"

var total_particles: int = 3


func _ready() -> void:
	new_particles_delay_timer.timeout.connect(
		_handle_new_particles_delay_timer_timeout
	)


func _start() -> void:
	new_particles_delay_timer.start()
	spawn_particles()

func _stop() -> void : 
	new_particles_delay_timer.stop()


func _handle_new_particles_delay_timer_timeout() -> void:
	binary_beep_sound.play()
	spawn_particles()


func spawn_particles() -> void:
	var shuffled_spawn_points: Array[Node3D] = (
		particle_spawn_points.duplicate()
	)

	shuffled_spawn_points.shuffle()

	var particles_to_spawn: int = min(
		total_particles,
		shuffled_spawn_points.size()
	)

	for index: int in range(particles_to_spawn):
		var particle_instance: Node3D = (
			matrix_particle_scene.instantiate()
		)

		particle_parent_node.add_child(particle_instance)

		particle_instance.global_position = (
			shuffled_spawn_points[index].global_position
		)
