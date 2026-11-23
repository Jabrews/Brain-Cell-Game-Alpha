extends Node

# components
@onready var smoke_particle : GPUParticles3D = $SmokeParticle
@onready var red_particle : GPUParticles3D = $RedParticle
@onready var orange_particle : GPUParticles3D = $OrangeParticle
@onready var black_particle : GPUParticles3D = $BlackParticle


func _show_particles() -> void:
	smoke_particle.one_shot = true
	red_particle.one_shot = true
	orange_particle.one_shot = true
	black_particle.one_shot = true

	smoke_particle.emitting = true
	red_particle.emitting = true
	orange_particle.emitting = true
	black_particle.emitting = true
