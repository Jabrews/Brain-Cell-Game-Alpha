extends Node

# componets
@onready var audio_manager : Node3D = $AudioManager
@onready var blood_plane_controller : Node3D = $BloodPlaneController
@onready var capacity_label_manager : Node3D = $CapacityLabelManager
@onready var floating_label_creator : Node3D = $FloatingLabelCreator
@onready var flood_blood_manager : Node3D = $FloorBloodManager

var curr_trash_filled : int = 0

func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_next_round)
	GLDefectEventMangerBus.connect('prisoners_extracted', _handle_prisoners_extracted)

func increment_trash_filled() :
	
	# if trying to increase pass max capacity
	if curr_trash_filled >= IVCellTrashcan.max_capaicty :
		handle_trash_filled_past_capacity()
		return
	
	curr_trash_filled += 1 
	
	capacity_label_manager._update_labels(curr_trash_filled, IVCellTrashcan.max_capaicty)
	
	# if this is positve increase play sound
	audio_manager._play_cell_added_to_trash()
	floating_label_creator._create_label()
	
	blood_plane_controller.update_blood_plane(curr_trash_filled)

func handle_trash_filled_past_capacity() :
	# note is always an increment-up
	curr_trash_filled += 1
	audio_manager._play_cell_added_to_trash()
	floating_label_creator._create_label()
	capacity_label_manager._update_labels(curr_trash_filled, IVCellTrashcan.max_capaicty)
	flood_blood_manager._grow_blood()

func _handle_panel_cell_recieved(loaded_cell) :
	# delete if loaded cell
	if loaded_cell :
		GLCellManagerBus.emit_signal('delete_selected_collected_cell', loaded_cell)
		GLDefectEventMangerBus.emit_signal('cell_added_to_trashcan')
		
		increment_trash_filled()

func _handle_next_round() :
	curr_trash_filled = 0
	blood_plane_controller._reset()
	capacity_label_manager._update_labels(curr_trash_filled, IVCellTrashcan.max_capaicty)
	flood_blood_manager._reset()
	
func _handle_prisoners_extracted(quanity : int) :
	var curr_quanitiy_index = 0
	
	while curr_quanitiy_index != quanity : 
		increment_trash_filled()
		await get_tree().create_timer(2.0).timeout
		curr_quanitiy_index += 1
		
	
	
