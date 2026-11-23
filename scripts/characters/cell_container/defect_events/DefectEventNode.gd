extends Node3D

class_name DefectEventNode


var parent_brain_cell_container: CharacterBody3D
var defect_event_type: String
var skip_event_notice: bool = false
var data : Dictionary = {}


func _ready() -> void:
	_ready_overide()


func defect_event_start() -> void:

	create_event_notice()
	_start()


# Override this.
func _ready_overide() -> void:
	pass


# Override this.
func _start() -> void:
	pass


func _stop() -> void:
	pass


# Override this.
func _toggle_cell_picked_up(_toggle_value: bool) -> void:
	pass


func create_event_notice() -> void:

	if skip_event_notice:
		return

	var cell_name: String = (
		parent_brain_cell_container
		.designated_brain_cell
		.name
	)

	match defect_event_type:

		'sickness':
			GLEventNoticeManagerBus.emit_signal(
				'create_event_notice',
				EventNotice.new(
					'defect_event',
					cell_name.to_upper() + ' is experiencing a infectious sickness.',
					{
						'cell_name': cell_name
					}
				)
			)
		'bubble' : 
			GLEventNoticeManagerBus.emit_signal(
				'create_event_notice',
				EventNotice.new(
					'defect_event',
					cell_name.to_upper() + ' is experiencing a bubble. Must be shaked',
					{
						'cell_name': cell_name
					}
				)
			)
			
		

		_:
			push_error(
				'unable to find event notice for node defect event type: ',
				defect_event_type
			)


func delete_event_notice() -> void:

	if skip_event_notice:
		return

	var cell_name: String = (
		parent_brain_cell_container
		.designated_brain_cell
		.name
	)

	GLEventNoticeManagerBus.emit_signal(
		'delete_event_notice_defect_cell',
		cell_name
	)
