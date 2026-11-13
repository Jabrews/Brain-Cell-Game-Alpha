extends Node

# components
@onready var light_manager : Node = $Logic/LightManager
@onready var refresh_ui : Node = $Logic/RefreshUi
@onready var attacher_box : Control =$AttacherUI/StatMainView/AttacherBox
@onready var compute_failure_penality : Node = $Logic/ComputeFailurePenality

var enabled : bool = false 
var failure_rate_enabled : bool = true
var loaded_cell_container : CharacterBody3D

var failure_rate : int = 0


func _recieve_cell_container(cell_container : CharacterBody3D) : 
	reset_state()
	
	loaded_cell_container = cell_container	
	
	# load cell into box
	attacher_box._load_cell(_get_loaded_cell())
	
	if failure_rate_enabled : 
		compute_failure_penality._compute()
	
	refresh_ui._refresh()
	
	light_manager._set_light_mode('green')
	

func _removed_cell_container(_cell_container : CharacterBody3D) : 
	
	reset_state()
	
	# load cell into box
	attacher_box._load_cell(null)
	
	refresh_ui._refresh()
	
	light_manager._set_light_mode('off')

func reset_state() :
	loaded_cell_container = null
	
	# reset replacement state
	for key in GLAttacherComponentBus.main_stat_replacement_state:
		GLAttacherComponentBus.main_stat_replacement_state[key] = null
		
	for key in GLAttacherComponentBus.main_stat_replacement_failure_penality:
		GLAttacherComponentBus.main_stat_replacement_failure_penality[key] = false

func _get_loaded_cell() -> BrainCell : 
	if loaded_cell_container : 
		return loaded_cell_container.designated_brain_cell
	else : 
		return null
