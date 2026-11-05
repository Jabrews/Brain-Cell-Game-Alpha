extends Node

# Info components
@onready var item_added_to_jar: Node3D = $ItemAddedToJar

# Timer components
@onready var auto_reset_delay_timer: Timer = $AutoResetDelayTimer
@onready var blink_info_timer: Timer = $BlinkInfoTimer

var blink_info: bool = false

var _current_info: Node3D


func _ready() -> void:
	GLJarComponentBus.add_jar_item.connect(_handle_add_jar_item)

	auto_reset_delay_timer.timeout.connect(_handle_auto_reset_delay_timeout)
	blink_info_timer.timeout.connect(_handle_blink_info_timeout)

	blink_info_timer.one_shot = false
	reset_info()


func _handle_add_jar_item(_jar_item: JarItem) -> void:
	display_info("item_added_to_jar")


func display_info(info_type: String) -> void:
	auto_reset_delay_timer.stop()
	reset_info()

	match info_type:
		"item_added_to_jar":
			_current_info = item_added_to_jar
			blink_info = true

	if _current_info == null:
		return

	_current_info.visible = true

	if blink_info:
		blink_info_timer.start()

	auto_reset_delay_timer.start()


func reset_info() -> void:
	blink_info_timer.stop()

	item_added_to_jar.visible = false
	_current_info = null
	blink_info = false


func _handle_blink_info_timeout() -> void:
	if _current_info != null:
		_current_info.visible = not _current_info.visible


func _handle_auto_reset_delay_timeout() -> void:
	reset_info()
