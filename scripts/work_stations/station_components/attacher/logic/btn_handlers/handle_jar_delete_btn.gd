extends Node

# components
@onready var handle_display_ui: Node = $"../../HandleDisplayUi"
@onready var delete_modal_manager : Node = $"../../DeleteModalManager"
@onready var refresh_ui : Node = $"../../RefreshUi"

var saved_jar_item: JarItem

func _handle(jar_item: JarItem) -> void:
	saved_jar_item = jar_item
	delete_modal_manager._toggle_modal(true)
	


func _handle_modal_btn_pressed(btn_type: String) -> void:
	var confirmed: bool = btn_type == "confirm"

	if confirmed:
		GLJarComponentBus.emit_signal("remove_jar_item", saved_jar_item)
		refresh_ui._refresh()

	saved_jar_item = null
	delete_modal_manager._toggle_modal(false)

	if confirmed:
		await get_tree().process_frame
		handle_display_ui._toggle_display(false)
