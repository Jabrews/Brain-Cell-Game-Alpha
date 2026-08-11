extends Control

@export var spot_num: int = 0
@onready var parent_event_notice_manager: Node = $".."

var spot_is_occupied: bool = false
