extends Node

# componnets
@onready var switch_screen : Node = $SwitchScreen
@onready var parent_station : Node3D = $"../../../.."

# demand display
@onready var stat_demand : Control = $Demand/StatDemand
@onready var mutation_demand : Control = $Demand/MutationDemand

# evluation helpers
@onready var cell_evaluation : Node = $Evaluations/CellEvaluation
@onready var mutation_evaluation : Node = $Evaluations/MutationEvaluation



func _load_demand(demand_type : String) :
	match demand_type : 
		'cell' :
			var demand_cell : BrainCell = parent_station.selected_offer_demand_constructor.demand_cell
			stat_demand._load_cell(demand_cell)
		'mutation' : 
			var demand_mutation : BrainCellMutation = parent_station.selected_offer_demand_constructor.demand_mutation
			mutation_demand._load_mutation(demand_mutation)

func _handle_cell_recieved(demand : ItemOfferDemandConstructor , brain_cell : BrainCell) :
	
	var compare_sucess : bool 
	
	match demand.demand_type:
		'cell' :
			compare_sucess = cell_evaluation._evaluate(brain_cell, demand.demand_cell)		
		'mutation' : 
			compare_sucess = mutation_evaluation._evaluate(brain_cell, demand.demand_mutation)
	
	return compare_sucess
		
						




			
			
			
	
	
	
	
