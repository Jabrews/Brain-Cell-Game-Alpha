extends Node


var max_rounds = 1
var current_round = 1

var curr_turn = 1

signal proceed_next_round()
signal proceed_next_turn()

signal process_next_round()


# after round fade to black
signal reset_player_position()
