extends Node

var input_type: String = "keyboard"

signal recieve_input_type_changed(new_input_type: String)


func _input(event: InputEvent) -> void:
	var new_input_type := input_type

	# controller
	if event is InputEventJoypadButton:
		new_input_type = "controller"

	elif event is InputEventJoypadMotion:
		# ignore tiny stick drift
		if abs(event.axis_value) > 0.2:
			new_input_type = "controller"


	# keyboard / mouse
	elif event is InputEventKey:
		if event.pressed:
			new_input_type = "keyboard"

	elif event is InputEventMouseButton:
		new_input_type = "keyboard"

	elif event is InputEventMouseMotion:
		# ignore tiny mouse movement
		if event.relative.length() > 1.0:
			new_input_type = "keyboard"


	_set_input_type(new_input_type)


func _set_input_type(new_input_type: String) -> void:
	if new_input_type == input_type:
		return

	input_type = new_input_type

	recieve_input_type_changed.emit(input_type)
