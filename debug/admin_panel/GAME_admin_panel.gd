extends Node

var enabled : bool = false 

var admin_panel_root : AdminPanelRoot
var updater_admin_batch_mutation : AdminBatchMutation
var updater_random_mutation_event : AdminRandomMutationEvent

# when save = false we dont save into json log
var save_updater_admin_batch_mutation : bool = false 
var save_random_mutation_event : bool = false
