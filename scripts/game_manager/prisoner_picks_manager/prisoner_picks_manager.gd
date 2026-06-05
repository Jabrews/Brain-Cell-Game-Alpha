extends Node

var last_pick_quanity_was_2 = false

func _ready() -> void:
	GLPrisonerPicksBus.connect('generate_next_max_prisoners_created', _handle_generate_next_max_prisoners_created)
	GLGameManagerBus.connect('proceed_next_round', _handle_next_round)

func _handle_next_round() :
	print("[Prisoner Picks] New round started. Resetting last_pick_quanity_was_2.")
	last_pick_quanity_was_2 = false

func _handle_generate_next_max_prisoners_created() :

	print("\n===== GENERATING PRISONER PICK LIMITS =====")
	print("Previous current max: ", GLPrisonerPicksBus.max_picked_pris_per_turn)
	print("Previous next max: ", GLPrisonerPicksBus.next_max_picked_pris_per_turn)
	print("last_pick_quanity_was_2: ", last_pick_quanity_was_2)

	## CURR PRISONERS PICKED ##
	GLPrisonerPicksBus.max_picked_pris_per_turn = GLPrisonerPicksBus.next_max_picked_pris_per_turn
	GLPrisonerPicksBus.curr_picked_pris_per_turn = 0

	print("Current max set to: ", GLPrisonerPicksBus.max_picked_pris_per_turn)
	print("Current picked reset to 0")

	GLPrisonerPicksBus.emit_signal('current_max_generated')

	### NEXT PRISONERS PICKED ####
	if last_pick_quanity_was_2 :

		print("Last pick quantity was 2. Forcing next max to 1.")

		GLPrisonerPicksBus.next_max_picked_pris_per_turn = 1
		last_pick_quanity_was_2 = false

	else :

		var random_choice = randi_range(1, 2)

		print("Rolled random choice: ", random_choice)

		GLPrisonerPicksBus.next_max_picked_pris_per_turn = random_choice

		if random_choice == 2 :
			print("Random choice was 2. Setting last_pick_quanity_was_2 = true")
			last_pick_quanity_was_2 = true

	print("New next max: ", GLPrisonerPicksBus.next_max_picked_pris_per_turn)
	print("last_pick_quanity_was_2 after generation: ", last_pick_quanity_was_2)

	GLPrisonerPicksBus.emit_signal('next_max_generated')

	print("===== GENERATION COMPLETE =====\n")
