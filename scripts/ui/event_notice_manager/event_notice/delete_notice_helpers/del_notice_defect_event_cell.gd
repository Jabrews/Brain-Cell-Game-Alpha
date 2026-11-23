extends Node

@onready var parent_event_notice : Control = $"../.."

func _ready() -> void:
	GLEventNoticeManagerBus.connect('delete_event_notice_defect_cell', _handle_delete_event_notice_defect_cell)

func _handle_delete_event_notice_defect_cell(selected_cell_name : String) :

	var designated_event_notice : EventNotice = parent_event_notice.designated_event_notice 
	
	if not designated_event_notice.event_type == 'defect_event' : 
		return
	
	if designated_event_notice.data.has('cell_name') :
		if designated_event_notice.data['cell_name'] == selected_cell_name :
			parent_event_notice._delete_early()
									
