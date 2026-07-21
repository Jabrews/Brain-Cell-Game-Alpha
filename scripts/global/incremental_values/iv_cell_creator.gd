extends Node

# min_stat_value = 0
var max_stat_value = 400
var total_stat_value = 400

# target
var target_stat_max = 145
var target_stat_min = 120

# out of 100
var chance_of_bad_stats = 50 # will flip the addition value
var chance_of_no_defect = 50 # just no defect at all
var chance_to_half_defect = 75
var chance_to_half_clean = 75

var clean_stat_addition_min = 6
var clean_stat_addition_max = 20
var defect_stat_addition_min = 6
var defect_stat_addition_max = 20

# when dealing with targeted cell mutation
var shareholder_demand_cell_mutation : BrainCellMutation = null
