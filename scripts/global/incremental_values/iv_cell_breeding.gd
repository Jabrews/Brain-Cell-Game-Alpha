extends Node

var max_cell_breeding_attempts = 5
var curr_cell_breeding_attempt = 0

### FOR CELL CONTAINER ###
var newly_breeded_cell_can_die_from_defect : bool = false


#### CLEAN stat helper ####

# controlls the % value we multiple high stat by to see if low meets increase case min.
# the lower the decimal the easier to get to increase case
# EXTRA : the low mode is below min and over (extreme) is above target. 
var clean_stat_increase_case_min = 0.4

## increase_clean_stat_case
# low increase value (under 0.5 of target ) scale increase value (early game)
var low_add_percant_scale = 0.7
var high_add_percant_scale = 0.6
###########################

#### DEFECT stat helper ####
	
# controlls the % value we multiple high stat by to see if low meets increase case min.
# the lower the decimal the easier to get to increase case
var defect_stat_increase_case_min = 0.5

# there are 5 diffrent equations we use for new defect in a increase case
# the equations look like this : 
# 1 : high_stat + low_stat + (low_stat / 2)
# 2 : high_stat + low_stat
# 3 : high_stat + (low_stat * 0.8)
# 4 : high_stat + (low_stat * 0.7)
# 5  :high_stat + low_stat
var defect_stat_increase_one_scale = 0.3
var defeect_stat_increase_three_scale = 0.6
var defect_stat_increase_four_scale = 0.5


###########################
