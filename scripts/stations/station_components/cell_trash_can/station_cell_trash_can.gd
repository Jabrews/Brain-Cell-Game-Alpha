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
	GLCellManagerBus.connect('cell_breeded', _handle_cell_breeded)
	GLCellTrashcanBus.connect('cell_deleted_from_shareholder_offer_station', _handle_cell_deleted_from_shareholder_offer_station)

func increment_trash_filled() :
	
	# if trying to increase pass max capacity
	if curr_trash_filled >= IVCellTrashcan.max_capaicty :
		handle_trash_filled_past_capacity()
		return
	
	curr_trash_filled += 1 
	
	GLCellTrashcanBus.emit_signal('cell_added_to_trashcan')
	
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
		increment_trash_filled()

func _handle_cell_breeded(_cell_1 : BrainCell, _cell_2 : BrainCell, _cell_3 : BrainCell,  _cell_4 : BrainCell, _cell_5 : BrainCell) :
	increment_trash_filled()
		

func _handle_next_round() :
	curr_trash_filled = 0
	blood_plane_controller._reset()
	capacity_label_manager._update_labels(curr_trash_filled, IVCellTrashcan.max_capaicty)
	flood_blood_manager._reset()

func _handle_cell_deleted_from_shareholder_offer_station() :
	increment_trash_filled()
