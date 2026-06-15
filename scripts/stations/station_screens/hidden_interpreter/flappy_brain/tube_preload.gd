
extends Node2D


@onready var tube_top: StaticBody2D = $TubeTop
@onready var tube_bottom: StaticBody2D = $TubeBottom


func _ready() -> void:
	_setup()

func _process(delta: float) -> void:
	global_position.x -= IVFlappyBrain.tube_speed * delta

func _setup() -> void:
	
	var center_y_scale_unit = randi_range(IVFlappyBrain.center_y_unit_min, IVFlappyBrain.center_y_unit_max)
	
	# get both completly filled
	tube_top.scale.y = center_y_scale_unit # 6
	tube_bottom.scale.y = 15 - tube_top.scale.y 
	
	# find largest tube
	var largest_tube : StaticBody2D
	if tube_top.scale.y > tube_bottom.scale.y : 
		largest_tube = tube_top
	else :
		largest_tube = tube_bottom
	
	var gap_bewteen_tubes = randf_range(IVFlappyBrain.gap_bewteen_tubes_min, IVFlappyBrain.gap_bewteen_tubes_max)
	
	# apply gap to that one
	largest_tube.scale.y -= gap_bewteen_tubes
	
