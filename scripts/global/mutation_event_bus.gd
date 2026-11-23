extends Node


signal attempt_to_trigger_random_mutation_event(mutation_event : MutationEvent, brain_cell : BrainCell)
signal trigger_random_mutation_failed()
signal finished_trigger_event(chosen_mutation_event_name: String)
