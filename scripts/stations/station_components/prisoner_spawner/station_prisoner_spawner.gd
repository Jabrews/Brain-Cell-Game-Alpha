extends Node

# componnets
@export var prisoners_parent_node : Node
@onready var prisoner_spots : Array[Node3D] = [
	$PrisonerSpawnSpots/Spot1,
	$PrisonerSpawnSpots/Spot2,
	$PrisonerSpawnSpots/Spot3,
	$PrisonerSpawnSpots/Spot4,
]
@onready var prisoner_instance : PackedScene = preload("res://scenes/characters/prisoner/Prisoner.tscn")
