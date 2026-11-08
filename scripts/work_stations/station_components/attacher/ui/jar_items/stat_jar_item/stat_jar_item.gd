extends Node

# components
@onready var bg: TextureRect = $BG
@onready var hover_border: TextureRect = $OutsideBorders/HoverBorder
@onready var dragging_border: TextureRect = $OutsideBorders/DraggingBorder
@onready var delete_btn: Control = $DeleteBtn
@onready var display_stat_jar_item : Node = $DisplayStatJarItem

var corrisponding_stat_jar_item: StatJarItem


func _ready() -> void:
	bg.mouse_entered.connect(_update_visuals)
	bg.mouse_exited.connect(_deferred_update)
	bg.focus_entered.connect(_update_visuals)
	bg.focus_exited.connect(_deferred_update)

	delete_btn.mouse_entered.connect(_update_visuals)
	delete_btn.mouse_exited.connect(_deferred_update)
	delete_btn.focus_entered.connect(_update_visuals)
	delete_btn.focus_exited.connect(_deferred_update)

	_update_visuals()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("console_debug"):
		bg.grab_focus()


func _start(stat_jar_item: StatJarItem) -> void:
	corrisponding_stat_jar_item = stat_jar_item
	display_stat_jar_item._display(corrisponding_stat_jar_item)


func _item_used() -> void:
	pass


func _deferred_update() -> void:
	call_deferred("_update_visuals")


func _update_visuals() -> void:
	var hovered_control: Control = get_viewport().gui_get_hovered_control()

	var is_hovered: bool = (
		hovered_control == bg
		or hovered_control == delete_btn
		or (
			hovered_control != null
			and (
				bg.is_ancestor_of(hovered_control)
				or delete_btn.is_ancestor_of(hovered_control)
			)
		)
	)

	var is_focused: bool = (
		bg.has_focus()
		or delete_btn.has_focus()
	)

	var active: bool = is_hovered or is_focused

	hover_border.visible = active
	delete_btn.visible = active
