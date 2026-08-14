extends Node

signal toggle_player_entered_provider_area(toggle_value)

var round_1_demand_items : Array[DemandItem] = [
	DemandItem.new('defect', 'blah_blah', 'blah blah blah blah blah blah'),
	DemandItem.new('prisoner', 'blah_blah', 'blah blah blah blah blah blah'),
	DemandItem.new('defect', 'blah_blah', 'blah blah blah blah blah blah'),
]

var round_2_demand_items : Array[DemandItem] = [
	DemandItem.new('defect', 'blah_blah', 'blah blah blah blah blah blah'),
	DemandItem.new('prisoner', 'blah_blah', 'blah blah blah blah blah blah'),
	DemandItem.new('defect', 'blah_blah', 'blah blah blah blah blah blah blah'),
]
