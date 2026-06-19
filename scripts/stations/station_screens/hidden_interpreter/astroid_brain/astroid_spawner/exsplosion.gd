extends Node2D

# componnets
@onready var particles : Node2D = $Particles


var astroid_max_health : int = 0

func _ready() -> void:
	if astroid_max_health<= 2 :
		scale = Vector2(0.5, 0.5)
	elif astroid_max_health > 2 and astroid_max_health <= 4 :
		scale = Vector2(0.7, 0.7)
	else :
		scale = Vector2(1.0, 1.0)
	
	for particle : GPUParticles2D in particles.get_children() :
		particle.emitting = true
	
	await get_tree().create_timer(3.0).timeout	
	
	queue_free()
	
	
	
