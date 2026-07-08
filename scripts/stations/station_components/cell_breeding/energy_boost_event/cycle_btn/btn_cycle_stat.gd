extends InteractableBtn

@export var side : String 
@export var direction : String 

# component event parent
@onready var handle_cycle_btn_pressed : Node = $"../../../../../EnergyBoostEventManager/HandleCycleBtnPressed"


func _on_btn_interacted() :
	handle_cycle_btn_pressed._handle_event_cycle_btn_pressed(side, direction)
