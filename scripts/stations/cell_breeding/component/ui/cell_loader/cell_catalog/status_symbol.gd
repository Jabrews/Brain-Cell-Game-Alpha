extends Node

# components
@onready var symbol_texture : TextureRect = $SymbolTexture
@onready var hover_rect : ColorRect = $Hover
@onready var hint_parent_node : Node = $"../../../../../../../../../HintParentNode"

# symbol textures
@onready var t_near_death_alert: Texture = preload("res://models/cell_breeder/ui/status_symbols/death_chance_status_symbol.png")
@onready var t_low_lifespan: Texture = preload("res://models/cell_breeder/ui/status_symbols/lifespan_status_symbol.png")
@onready var t_on_goal_interface: Texture = preload("res://models/cell_breeder/ui/status_symbols/on_goal_status_symbol.png")
@onready var t_breeder_unavailable: Texture = preload("res://models/cell_breeder/ui/status_symbols/unavaible_status_symbol.png")


# hint creation
var status_symbol_hint_p_s : PackedScene = preload("res://scenes/stations/cell_breeding/ui/cell_loader/cell_catalog/status_symbol_hint.tscn")
var active_hint : Control



enum Status {
	NEAR_DEATH_ALERT,
	LOW_LIFESPAN,
	ON_GOAL_INTERFACE,
	BREEDER_UNAVAILABLE
}

@export var status: Status = Status.NEAR_DEATH_ALERT

func _ready() -> void:
	symbol_texture.texture = get_status_texture()
	
	connect('mouse_entered', _handle_mouse_entered)	
	connect('mouse_exited', _handle_mouse_exited)	
	
	
func _handle_mouse_entered() :
	hover_rect.visible = true
	_toggle_create_hint(true)

func _handle_mouse_exited() :
	hover_rect.visible = false
	_toggle_create_hint(false)
	

func get_status_texture() -> Texture:
	match status:
		Status.NEAR_DEATH_ALERT:
			return t_near_death_alert
			
		Status.LOW_LIFESPAN:
			return t_low_lifespan
			
		Status.ON_GOAL_INTERFACE:
			return t_on_goal_interface
			
		Status.BREEDER_UNAVAILABLE:
			return t_breeder_unavailable
	
	return null

func get_hint_text() -> String :
	match status:
		Status.NEAR_DEATH_ALERT:
			return 'Cell is nearing death. Breeding will likely end in the cells death.'
			
		Status.LOW_LIFESPAN:
			return 'Cell has a low lifespan. Breeding will likely end in the cells death.'
			
		Status.ON_GOAL_INTERFACE:
			return 'this Cell is currently contributing to the goal interace.'
			
		Status.BREEDER_UNAVAILABLE:
			return 'this Cell has already bread this turn and is not available'
		
		_ :
			return 'issue finding hint text'

func _toggle_create_hint(toggle_value: bool) -> void:
	
	if toggle_value:
		# don't create two
		if active_hint != null:
			return
		
		active_hint = status_symbol_hint_p_s.instantiate()
		hint_parent_node.add_child(active_hint)
		
		var hint_text : String = get_hint_text()
		active_hint.hint_label.text = hint_text
		
		
		#active_hint.global_position = get_viewport().get_mouse_position()
		active_hint.global_position = symbol_texture.global_position + Vector2(35, 35)
		
	
	else:
		if active_hint != null:
			active_hint.queue_free()
			active_hint = null

		
	
	
