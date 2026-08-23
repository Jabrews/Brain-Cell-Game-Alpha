extends Node

@onready var bubble: GPUParticles3D = $Bubble

var bubble_material: StandardMaterial3D


func _ready() -> void:
	bubble.emitting = true
	bubble.amount = 9
	
	bubble_material = bubble.draw_pass_1.material
	
	bubble_material.albedo_color = Color.RED


func _handle_shake_progress(curr_shake_progess: float) -> void:
	
	match curr_shake_progess:
		0.25:
			bubble.amount = 7
			_set_bubble_color(Color(1.0, 0.75, 0.75))
		
		0.50:
			bubble.amount = 5
			_set_bubble_color(Color(1.0, 0.85, 0.85))
		
		0.75:
			bubble.amount = 3
			_set_bubble_color(Color(1.0, 0.93, 0.93))
		
		1.00:
			bubble.amount = 1
			_set_bubble_color(Color.WHITE)


func _set_bubble_color(color: Color) -> void:
	bubble_material.albedo_color = color
