extends Node

@onready var parent_event_notice : Control = $"../.."

func _ready() -> void:
	GLEventNoticeManagerBus.connect('delete_event_notice_shareholder_item_offer', _handle_delete_event_notice_shareholder_item_offer)

func _handle_delete_event_notice_shareholder_item_offer(serve_num: int) :

	var designated_event_notice : EventNotice = parent_event_notice.designated_event_notice 
	
	if not designated_event_notice.event_type == 'default' : 
		return
	
	if designated_event_notice.data.has('serve_num') :
		if designated_event_notice.data['serve_num'] == serve_num:
			parent_event_notice._delete_early()
									
