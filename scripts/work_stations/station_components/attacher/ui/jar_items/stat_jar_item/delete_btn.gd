extends Control

# components
@onready var delete_btn_bg: ColorRect = $BG
@onready var hover_border: ColorRect = $HoverBorder
@onready var hint_parent: Control = $DeleteHintParent

# stop focus components
@onready var parent_bg: TextureRect = $"../../../BG"

# parent
@onready var parent_stat_jar_item: Control = $"../../.."

# handlers
@onready var handle_delete_jar_btn: Node = $"../../../../../../../../../../Logic/BtnHandlers/HandleJarDeleteBtn"


func _ready() -> void:
	delete_btn_bg.mouse_entered.connect(_update_visuals)
	delete_btn_bg.mouse_exited.connect(_update_visuals)
	delete_btn_bg.focus_entered.connect(_update_visuals)
	delete_btn_bg.focus_exited.connect(_update_visuals)

	# handle input directly through the delete btn
	delete_btn_bg.gui_input.connect(_handle_gui_input)

	delete_btn_bg.focus_mode = Control.FOCUS_ALL
	delete_btn_bg.mouse_filter = Control.MOUSE_FILTER_STOP

	_update_visuals()


func _handle_gui_input(event: InputEvent) -> void:
	if parent_stat_jar_item.is_used or parent_stat_jar_item.dragging:
		return

	if GLAttacherComponentBus.showing_delete_modal:
		return

	if event.is_action_pressed("attack") or event.is_action_pressed("interact"):
		# prevent input from propagating to parent
		delete_btn_bg.accept_event()

		_handle_btn_pressed()


func _is_active() -> bool:
	return (
		delete_btn_bg.get_global_rect().has_point(
			delete_btn_bg.get_global_mouse_position()
		)
		or delete_btn_bg.has_focus()
	)


func _update_visuals() -> void:
	var active: bool = _is_active()

	if parent_stat_jar_item.is_used or parent_stat_jar_item.dragging:
		active = false

	hover_border.visible = active
	hint_parent.visible = active


func _handle_btn_pressed() -> void:
	if GLAttacherComponentBus.showing_delete_modal:
		return

	handle_delete_jar_btn._handle(
		parent_stat_jar_item.corrisponding_stat_jar_item
	)

	await get_tree().process_frame

	delete_btn_bg.release_focus()
	parent_bg.release_focus()

	_update_visuals()
