extends Node

# components
@onready var parent_main_stat : Control = $".."
# default
@onready var default_detect_rect : ColorRect = $"../DefaultDetectRect"
@onready var mouse_hover_border : TextureRect = $"../DragBorders/MouseHoverBorder"
@onready var drag_invalid_border : TextureRect = $"../DragBorders/DragInvalidBorder"
# no replacement hover needed
# hint parents
@onready var drag_a_jar_item_hint : Control = $"../HoverHints/DragAJarItemHint"
@onready var stat_unable_to_drag_hint : Control = $"../HoverHints/StatUnableToDragHint"

func _ready() -> void:
	default_detect_rect.connect('mouse_entered', _handle_mouse_entered)	
	default_detect_rect.connect('mouse_exited', _handle_mouse_exited)	
	default_detect_rect.connect('focus_entered', _handle_mouse_entered)	
	default_detect_rect.connect('focus_exited', _handle_mouse_exited)	

func _handle_mouse_entered() :
	#if parent_main_stat.main_stat_enabled : 
	drag_a_jar_item_hint.visible = true
	mouse_hover_border.visible = true
	#else : 
		#stat_unable_to_drag_hint.visible = true
		#drag_invalid_border.visible = true
#
func _handle_mouse_exited() :
	# border reset
	drag_a_jar_item_hint.visible = false
	mouse_hover_border.visible = false
	# hint reset
	#drag_a_jar_item_hint.visible = false 
	#stat_unable_to_drag_hint.visible = false 
