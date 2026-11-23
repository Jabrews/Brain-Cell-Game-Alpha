extends Node

@onready var parent_event_notice: Control = $"../.."


func _ready() -> void:
	GLEventNoticeManagerBus.connect(
		"delete_event_notice_hidden_stat_interpreter",
		_handle_delete_event_notice_defect_cell
	)


func _handle_delete_event_notice_defect_cell(
	selected_interpreter: String
) -> void:

	var designated_event_notice: EventNotice = (
		parent_event_notice.designated_event_notice
	)

	if designated_event_notice.event_type != "defect_event":
		return

	if not designated_event_notice.data.has("interpreters"):
		return

	var interpreters: Array = designated_event_notice.data["interpreters"]

	interpreters.erase(selected_interpreter)

	# Delete notice once no interpreters remain.
	if interpreters.is_empty():
		parent_event_notice._delete_early()
