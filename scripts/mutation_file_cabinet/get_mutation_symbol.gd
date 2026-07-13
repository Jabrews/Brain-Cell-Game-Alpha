extends Node

@onready var disrupt_img : Texture = preload(
	"res://models/mutation_symbols/disrupt.png"
)
@onready var exsplosive_img : Texture = preload(
	"res://models/mutation_symbols/exsplosive.png"
)
@onready var flying_img : Texture = preload(
	"res://models/mutation_symbols/flying.png"
)
@onready var infectious_img : Texture = preload(
	"res://models/mutation_symbols/infectious.png"
)
@onready var lonley_img : Texture = preload(
	"res://models/mutation_symbols/lonley.png"
)
@onready var look_img : Texture = preload(
	"res://models/mutation_symbols/look.png"
)
@onready var psychic_img : Texture = preload(
	"res://models/mutation_symbols/phyicic.png"
)
@onready var sentient_img : Texture = preload(
	"res://models/mutation_symbols/sentient.png"
)
@onready var telecantic_img : Texture = preload(
	"res://models/mutation_symbols/sentient.png"
)
@onready var teleport_img : Texture = preload(
	"res://models/mutation_symbols/teleport.png"
	
)

func get_symbol(mutation_type : String) :
	match mutation_type : 
		'airborne' :
			return flying_img
		'teleportation' : 
			return teleport_img
		'sentient' : 
			return sentient_img
		'lonley' : 
			return lonley_img
	
		
	
	
