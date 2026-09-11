extends Node

# components
@onready var symbol_texture: TextureRect = $SymbolTexture
@onready var hover_rect: ColorRect = $Hover
@onready var hint_parent_node: Node = $"../../../../../../../../../HintParentNode"

# symbol textures
@onready var t_near_death_alert: Texture = preload("res://models/cell_breeder/ui/status_symbols/death_chance_status_symbol.png")
@onready var t_low_lifespan: Texture = preload("res://models/cell_breeder/ui/status_symbols/lifespan_status_symbol.png")
@onready var t_on_goal_interface: Texture = preload("res://models/cell_breeder/ui/status_symbols/on_goal_status_symbol.png")
@onready var t_breeder_unavailable: Texture = preload("res://models/cell_breeder/ui/status_symbols/unavaible_status_symbol.png")

# hint creation
var status_symbol_hint_p_s: PackedScene = preload("res://scenes/stations/cell_breeding/ui/cell_loader/cell_catalog/status_symbol_hint.tscn")
var active_hint: Control


@export_enum(
	"near_death_alert",
	"low_lifespan",
	"on_goal_interface",
	"breeder_unavailable"
)
var status: String = "near_death_alert"


func _ready() -> void:
	symbol_texture.texture = get_status_texture()

	connect("mouse_entered", _handle_mouse_entered)
	connect("mouse_exited", _handle_mouse_exited)


func _handle_mouse_entered() -> void:
	hover_rect.visible = true
	_toggle_create_hint(true)


func _handle_mouse_exited() -> void:
	hover_rect.visible = false
	_toggle_create_hint(false)


func get_status_texture() -> Texture:
	match status:
		"near_death_alert":
			return t_near_death_alert

		"low_lifespan":
			return t_low_lifespan

		"on_goal_interface":
			return t_on_goal_interface

		"breeder_unavailable":
			return t_breeder_unavailable

	return null


func get_hint_text() -> String:
	match status:
		"near_death_alert":
			return "Cell is nearing death. Breeding will likely end in the cell's death."

		"low_lifespan":
			return "Cell has a low lifespan. Breeding will likely end in the cell's death."

		"on_goal_interface":
			return "This cell is currently contributing to the goal interface."

		"breeder_unavailable":
			return "This cell has already bred this turn and is not available."

		_:
			return "Issue finding hint text."


func _toggle_create_hint(toggle_value: bool) -> void:

	if toggle_value:

		if active_hint != null:
			return

		active_hint = status_symbol_hint_p_s.instantiate()
		hint_parent_node.add_child(active_hint)

		active_hint.hint_label.text = get_hint_text()

		active_hint.global_position = (
			symbol_texture.global_position + Vector2(35, 35)
		)

	else:

		if active_hint != null:
			active_hint.queue_free()
			active_hint = null
