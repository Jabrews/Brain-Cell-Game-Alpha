extends InteractableBtn

@export var cell_seat_num : int
@export var direction : String 

# component helper / parent
@onready var handle_cycle_stat_btn : Node = $"../../../../HandleCycleStatBtn"


func _on_btn_interacted() :
	handle_cycle_stat_btn._handle(direction, cell_seat_num)
