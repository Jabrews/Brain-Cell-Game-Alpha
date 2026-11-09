extends Node

# components
@onready var parent_drag_stat_jar_item: Control = $".."
@onready var display_background: TextureRect = $"../DisplayBG"

# main stat components
@onready var strength_main_stat: Control = $"../../../StatMainView/Stats/Strength"
@onready var intelligence_main_stat: Control = $"../../../StatMainView/Stats/Intelligence"
@onready var community_main_stat: Control = $"../../../StatMainView/Stats/Community"

# detection radius
@export var stat_drop_radius: float = 20.0


func _handle() -> void:
	
	var loaded_jar_item: StatJarItem = parent_drag_stat_jar_item.loaded_stat_jar_item

	if loaded_jar_item == null:
		return

	var drag_rect: Rect2 = display_background.get_global_rect()

	# strength
	if drag_rect.intersects(
		_get_increased_rect(strength_main_stat.default_detect_rect, stat_drop_radius)
	):
		strength_main_stat._handle_stat_jar_item_dropped(loaded_jar_item)

	# intelligence
	elif drag_rect.intersects(
		_get_increased_rect(intelligence_main_stat.default_detect_rect, stat_drop_radius)
	):
		intelligence_main_stat._handle_stat_jar_item_dropped(loaded_jar_item)

	# community
	elif drag_rect.intersects(
		_get_increased_rect(community_main_stat.default_detect_rect, stat_drop_radius)
	):
		community_main_stat._handle_stat_jar_item_dropped(loaded_jar_item)

	# invalid drop
	else:
		pass


func _get_increased_rect(control: Control, radius: float) -> Rect2:
	var global_rect: Rect2 = control.get_global_rect()
	return global_rect.grow(radius)
