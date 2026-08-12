extends Control

@onready var event_notice_p_s: PackedScene = preload(
	"res://scenes/ui/event_notice.tscn"
)

@onready var spots: Array[Control] = [
	$Spot1,
	$Spot2,
	$Spot3,
	$Spot4
]

func _ready() -> void:
	GLEventNoticeManagerBus.connect('create_event_notice', _create_event_notice)
	GLEventNoticeManagerBus.connect('toggle_hide_event_notice', _handle_toggle_hide_event_notice )

func _create_event_notice(event_notice: EventNotice) -> void:
	
	if event_notice.event_type == 'defect_event' or event_notice.event_type == 'mutation_event'	 :
		await get_tree().create_timer(1.0).timeout
	
	var valid_spot: Control = get_valid_spot()

	if valid_spot == null:
		return

	var event_instance: Control = event_notice_p_s.instantiate()

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

			# Update occupancy BEFORE moving.
			source_spot.spot_is_occupied = false
			target_spot.spot_is_occupied = true

			event_notice.reparent(target_spot)
			event_notice.position = Vector2.ZERO
			
			break

func _handle_toggle_hide_event_notice(toggle_value : bool): 
	visible = toggle_value	
	
