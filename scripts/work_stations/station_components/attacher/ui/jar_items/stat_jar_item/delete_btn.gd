extends Control

# components
@onready var delete_btn_bg: ColorRect = $BG
@onready var hover_border: ColorRect = $HoverBorder
@onready var delete_hint: Control = $DeleteHint

# parent components
@onready var parent_stat_jar_item: Node = $".."
@onready var parent_hover_border: TextureRect = $"../OutsideBorders/HoverBorder"

# handlers
@onready var handle_delete_jar_btn: Node = $"../../../../../../../Logic/BtnHandlers/HandleJarDeleteBtn"

var hovered: bool = false


func _ready() -> void:
	mouse_entered.connect(_update_visuals)
	mouse_exited.connect(_deferred_update)

	focus_entered.connect(_update_visuals)
	focus_exited.connect(_deferred_update)

	_update_visuals()


func _process(_delta: float) -> void:
	var active: bool = hovered or has_focus()

	if active:
		if Input.is_action_just_pressed("attack") :
			var jar_item: StatJarItem = parent_stat_jar_item.corrisponding_stat_jar_item
			handle_delete_jar_btn._handle(jar_item)
		if Input.is_action_just_pressed("interact"):
			var jar_item: StatJarItem = parent_stat_jar_item.corrisponding_stat_jar_item
			handle_delete_jar_btn._handle(jar_item)
		


func _deferred_update() -> void:
	call_deferred("_update_visuals")


func _update_visuals() -> void:
	var hovered_control: Control = get_viewport().gui_get_hovered_control()

	var is_hovered: bool = (
		hovered_control == self
		or (
			hovered_control != null
			and is_ancestor_of(hovered_control)
		)
	)

	var active: bool = is_hovered or has_focus()

	hovered = active
	hover_border.visible = active
	delete_hint.visible = active

	if active:
		parent_hover_border.visible = true
	else:
		parent_stat_jar_item._deferred_update()
