extends Node

# componnets
@onready var ship_duplicate_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/astroid_brain/ship/ship_duplicate.tscn")
@onready var ship_parent : CharacterBody2D = $".."
@onready var ship_duplicates_parent_node : Node2D = $"../ShipDuplicates"

var current_ships : Array[CharacterBody2D] = []


func _ready() -> void:
	GLInterpreterGames.connect('ship_collected_bubble', _handle_ship_collected_bubble)
	GLInterpreterGames.connect('child_ship_died', _handle_child_ship_died)

func _handle_ship_collected_bubble() -> void:
	call_deferred("create_ship")

func create_ship() :
	var ship_instance : CharacterBody2D = ship_duplicate_scene.instantiate()
	ship_duplicates_parent_node.add_child(ship_instance)	
	
	
	# set ship position
	var ship_y_position : float = ship_parent.global_position.y
	var ship_x_position : float = 0.0
	
	# get x position
	# if more than one extra ship
	if len(current_ships) > 0 : 
		var finale_index : int = len(current_ships) - 1
		
		# make sure its even on each side. so we add one ship on left and one ship on right
		# use moduloso 
		
		ship_x_position = current_ships[finale_index].global_position.x + 15.5
	# if just one
	else : 
		ship_x_position = ship_parent.global_position.x + 15.5 

	ship_instance.global_position = Vector2(ship_x_position, ship_y_position)
	
	current_ships.append(ship_instance)

func _shoot() :		
	for ship : CharacterBody2D in current_ships :		
		ship._shoot()
	
	
func _handle_child_ship_died(ship_child_instance : CharacterBody2D) :
	for ship : CharacterBody2D in current_ships :
		if ship == ship_child_instance : 
			current_ships.erase(ship)
	
	
	
	
	
