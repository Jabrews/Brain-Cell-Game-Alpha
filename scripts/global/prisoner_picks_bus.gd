extends Node

signal generate_next_max_prisoners_created()
signal next_max_generated()

signal current_max_generated()

var next_max_picked_pris_per_turn = 1
var max_picked_pris_per_turn = 0
var curr_picked_pris_per_turn = 0
