extends Node


# components
@onready var lights : Array[SpotLight3D] = [
	$Light1, $Light2
]


func _toggle_lights(toggle_value : bool) :
	for light : SpotLight3D in lights : 
		light.visible = toggle_value			
