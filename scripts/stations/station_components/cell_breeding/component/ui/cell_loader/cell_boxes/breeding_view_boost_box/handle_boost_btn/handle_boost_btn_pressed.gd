extends Node

# visual components
@onready var t_inactive : Texture = preload("res://models/cell_breeder/ui/cell_reciever_box/boost_btn_inactive.png" )
@onready var t_default : Texture = preload("res://models/cell_breeder/ui/cell_reciever_box/boost_btn_default.png" )


@onready var boost_btn : TextureRect = $"../BoostBtn/BoostBtn"
@onready var boost_btn_hover : TextureRect = $"../BoostBtn/Hover"
@onready var parent_box : Control =$".."
@onready var must_add_charge_cell_hint : Control =  $"../MustAddChargeCellHint"

var loaded_cell : BrainCell
var hovered : bool = false

func _ready() -> void:
	
	boost_btn.connect('mouse_entered', _handle_mouse_entered)
	boost_btn.connect('mouse_exited', _handle_mouse_exited)
	boost_btn.connect('focus_entered', _handle_mouse_entered)
	boost_btn.connect('focus_exited', _handle_mouse_exited)
	
	GLBreedingComponetsBus.connect('toggle_boost_activated', _handle_toggle_boost_activated)	
	
	
	# set holo off
	boost_btn.material.set_shader_parameter('hologram_enabled', false)
	# default is inactive, so low opacity
	boost_btn.modulate.a = 0.5
	
func _process(_delta: float) -> void:	
	if loaded_cell : 
		if hovered : 
			if Input.is_action_just_pressed('attack')  or Input.is_action_just_pressed('interact'):
				parent_box.handle_boost_display._handle(parent_box.side)
	

func _handle_mouse_entered() :
	
	if loaded_cell : 
		
		hovered = true
		
		boost_btn_hover.visible = true
	
	else : 
		
		if parent_box.side == 'right' : 	
			must_add_charge_cell_hint.position = Vector2(-237.0, -5.0)
			
			
		must_add_charge_cell_hint.visible = true

func _handle_mouse_exited() :
	
	if loaded_cell : 
		
		hovered = false		
		
		boost_btn_hover.visible = false 
		
		
	must_add_charge_cell_hint.visible = false

func _handle_loaded_cell_changed(cell : BrainCell) :
	
	loaded_cell = cell
	
	if loaded_cell :
		boost_btn.texture = t_default
		boost_btn.modulate.a = 1.0
	else :
		boost_btn.texture = t_inactive
		boost_btn.modulate.a = 0.5
				
		
func _handle_toggle_boost_activated(side : String, toggle_value: bool) : 
	
	if side != parent_box.side :
		return
		
	boost_btn.material.set_shader_parameter('hologram_enabled', toggle_value)

		
	
