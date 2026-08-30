
extends Control

@export var low_opacity: float = 0.25
@export var high_opacity: float = 0.80
@export var flash_speed: float = 4.0

var time := 0.0


func _process(delta: float) -> void:
	time += delta
	
	var opacity = lerp(
		low_opacity,
		high_opacity,
		(sin(time * flash_speed) + 1.0) / 2.0
	)
	
	_set_children_opacity(self, opacity)


func _set_children_opacity(node: Node, opacity: float) -> void:
	for child in node.get_children():
		if child is CanvasItem:
			child.modulate.a = opacity
		
		_set_children_opacity(child, opacity)
