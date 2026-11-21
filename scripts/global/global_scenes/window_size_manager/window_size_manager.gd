extends Node

signal window_resized(new_size: Vector2i)

var window_size : Vector2i

func _ready() -> void:
	get_viewport().size_changed.connect(_on_window_resized)
	
	window_size = get_window().size
	emit_signal('window_resized', window_size)
	

func _on_window_resized() -> void:
	var new_size: Vector2i = get_window().size
	
	window_size = new_size
	emit_signal('window_resized', window_size)
	
