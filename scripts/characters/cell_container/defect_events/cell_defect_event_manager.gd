extends Node


# components
@onready var parent_cell_container: CharacterBody3D = $".."
@onready var defect_event_parent_node: Node3D = $DefectEventParentNode


# defect event nodes
@onready var sickness_defect_event_p_s: PackedScene = preload(
	"res://scenes/characters/cell_container/defect_events/defect_event_nodes/sickness/sickness_defect_event.tscn"
)


func _ready() -> void:

	GLDefectEventMangerBus.connect('initate_defect_event_cell_container', _handle_initate_defect_event_cell_container)


func _handle_initate_defect_event_cell_container(defect_event_type: String, cell_name: String, skip_event_notice : bool, data : Dictionary) -> void:

	if parent_cell_container.designated_brain_cell.name != cell_name:
		return
	
	# make sure not to create multiple of the same defect event node on the same cell.
	for defect_event_node: DefectEventNode in defect_event_parent_node.get_children():
		if defect_event_node.defect_event_type == defect_event_type:
			return

	var event_node: DefectEventNode = (
		get_defect_event_corrisponding_node(defect_event_type)
	)
	
	event_node.name = defect_event_type
	event_node.defect_event_type = defect_event_type
	event_node.skip_event_notice = skip_event_notice
	event_node.parent_brain_cell_container = parent_cell_container
	event_node.data = data
	defect_event_parent_node.add_child(event_node)
	
	event_node.defect_event_start()

func get_defect_event_corrisponding_node(defect_event: String) -> DefectEventNode:

	match defect_event:

		'sickness':
			return sickness_defect_event_p_s.instantiate() as DefectEventNode

		_:
			push_error(
				'trouble finding corresponding defect event node for: ',
				defect_event
			)

			return null


#### CELL PICKUP #####

func _handle_cell_picked_up(toggle_value: bool) -> void:

	for defect_event_node: DefectEventNode in defect_event_parent_node.get_children():

		defect_event_node._toggle_cell_picked_up(toggle_value)
