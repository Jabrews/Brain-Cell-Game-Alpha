extends Node

var enabled : bool = true

var admin_panel_root : AdminPanelRoot
var updater_admin_batch_mutation : AdminBatchMutation
var updater_random_mutation_event : AdminRandomMutationEvent


# when save = false we dont save into json log
var save_updater_admin_batch_mutation : bool = true
var save_random_mutation_event : bool = true 
