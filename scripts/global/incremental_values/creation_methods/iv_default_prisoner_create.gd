extends Node


var equal_defect_weight_under_50: float = 0.0
var above_defect_weight_under_50: float = 0.0

var equal_defect_weight_50_to_under_75: float = 0.0
var above_defect_weight_50_to_under_75: float = 0.0

var equal_defect_weight_75_and_above: float = 0.0
var above_defect_weight_75_and_above: float = 0.0

# under defect specific

# under defect generation means : `rand_i_range(0.0, 75% of clean value)`
# this value cause the 0.0 minimun to increase along with defect value slightly
# so even when a bad_defect_rate stat gets lucky its still somewhat diffential from the good ones 
var under_defect_stat_defect_min_increase = 0.5
