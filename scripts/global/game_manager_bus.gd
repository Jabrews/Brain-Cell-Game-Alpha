extends Node


var max_rounds = 1
var current_round = 1

var curr_turn = 1


# not used for this iteration
#signal proceed_next_round()
#signal process_next_round()

# called by profiler after each turn to update ivs
signal proceed_next_turn()

# called after goal_piece done to update ivs
signal proceed_next_goal_piece()

# called after iv update. recieved by components needing new vars
signal process_new_ivs()


# after round fade to black helper
signal reset_player_position()
