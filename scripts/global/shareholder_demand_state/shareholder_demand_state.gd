extends Node

signal toggle_player_entered_provider_area(toggle_value)

var active_demands: Dictionary[int, bool] = {
	1: false,
	2: false,
	3: false,
	4: false,
	5: false,
	6: false,
}

var provided_demand_items: Array[DemandItem]


var round_1_demand_items: Array[DemandItem] = [
	DemandItem.new("defect", 1, "blah_blah", "blah blah blah blah blah blah", 10),
	DemandItem.new("prisoner", 2, "blah_blah", "blah blah blah blah blah blah", 15),
	DemandItem.new("defect", 3, "blah_blah", "blah blah blah blah blah blah", 20),
]

var round_2_demand_items: Array[DemandItem] = [
	DemandItem.new("defect", 4, "blah_blah", "blah blah blah blah blah blah", 10),
	DemandItem.new("prisoner", 5, "blah_blah", "blah blah blah blah blah blah", 15),
	DemandItem.new("defect", 6, "blah_blah", "blah blah blah blah blah blah", 20),
]


func _ready() -> void:
	GLGameManagerBus.connect(
		"process_next_round",
		_handle_next_round
	)


func _handle_next_round() -> void:
	for demand_id: int in active_demands.keys():
		active_demands[demand_id] = false
