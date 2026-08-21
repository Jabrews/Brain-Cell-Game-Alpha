extends Node

# components sprites
@onready var two_prisoners_sprite : Sprite3D = $TwoPrisoners
@onready var one_prisoners_sprite : Sprite3D = $OnePrisoner
@onready var empty_room_sprite : Sprite3D = $EmptyRoom
@onready var blood_overlay : Sprite3D = $BloodOverlay


func _switch_screen(screen_type : String) :
	
	reset()	
	
	match screen_type : 
		'empty' : 
			empty_room_sprite.visible = true
		'1_prisoner' :
			one_prisoners_sprite.visible = true
		'2_prisoner' :
			two_prisoners_sprite.visible = true

func reset() : 
	two_prisoners_sprite.visible = false
	one_prisoners_sprite.visible = false
	empty_room_sprite.visible = false

func _toggle_blood(toggle_value : bool) : 
	blood_overlay.visible = toggle_value	
	blood_overlay._toggle_effect(toggle_value)
