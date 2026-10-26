extends Control

const EVENT_NOTICE_SCENE: PackedScene = preload(
	"res://scenes/ui/event_notice.tscn"
)

@onready var spots: Array[Control] = [
	$Spot1,
	$Spot2,
	$Spot3,
	$Spot4
]

var event_notice_queue: Array[EventNotice] = []
var queue_active: bool = false


func _ready() -> void:
	GLEventNoticeManagerBus.connect(
		"create_event_notice",
		_create_event_notice
	)
	GLEventNoticeManagerBus.connect(
		"toggle_hide_event_notice",
		_handle_toggle_hide_event_notice
	)
	GLCinnamaticBus.connect(
		"toggle_cinnamatic_active",
		_handle_toggle_cinnamatic_active
	)


func _create_event_notice(event_notice: EventNotice) -> void:
	if queue_active:
		event_notice_queue.append(event_notice)
		return

	if event_notice.event_type in ["defect_event", "mutation_event"]:
		await get_tree().create_timer(1.0).timeout

		# A cinematic may have started during the delay.
		if queue_active:
			event_notice_queue.append(event_notice)
			return

	var valid_spot: Control = get_valid_spot()

	if valid_spot == null:
		return

	var event_instance: Control = EVENT_NOTICE_SCENE.instantiate()
	event_instance.designated_event_notice = event_notice

	valid_spot.spot_is_occupied = true
	valid_spot.add_child(event_instance)

	event_instance.position = Vector2.ZERO


func get_valid_spot() -> Control:
	for spot: Control in spots:
		if not spot.spot_is_occupied:
			return spot

	return null


func _handle_spot_freed() -> void:
	for target_index: int in range(spots.size()):
		var target_spot: Control = spots[target_index]

		if target_spot.spot_is_occupied:
			continue

		for source_index: int in range(target_index + 1, spots.size()):
			var source_spot: Control = spots[source_index]

			if not source_spot.spot_is_occupied:
				continue

			if source_spot.get_child_count() == 0:
				source_spot.spot_is_occupied = false
				continue

			var event_notice: Control = source_spot.get_child(0)

			source_spot.spot_is_occupied = false
			target_spot.spot_is_occupied = true

			event_notice.reparent(target_spot)
			event_notice.position = Vector2.ZERO
			break


func _handle_toggle_hide_event_notice(toggle_value: bool) -> void:
	visible = toggle_value


func _handle_toggle_cinnamatic_active(toggle_value: bool) -> void:
	queue_active = toggle_value

	if queue_active:
		return

	# Clear the original queue before initiating notices.
	var queued_notices: Array[EventNotice] = event_notice_queue.duplicate()
	event_notice_queue.clear()

	for event_notice: EventNotice in queued_notices:
		_create_event_notice(event_notice)
