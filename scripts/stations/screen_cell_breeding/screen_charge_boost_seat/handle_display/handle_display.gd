extends Node

# display helper loader componnets
@onready var energy_seat_loader : Node = $EnergySeatLoader
@onready var cycled_active_stat_loader : Node = $CycledActiveStatLoader

func _handle_display(
		energy_seat_cell : BrainCell,
		cycled_index : int,
		cycled_stat : String,
	) :
		
		
	# update main cell loader
	energy_seat_loader._handle_recieve_energy_seat_cell(
		energy_seat_cell,
	)
	
	cycled_active_stat_loader._handle_recieve_cycled(
		cycled_index,
		cycled_stat
	)

	
