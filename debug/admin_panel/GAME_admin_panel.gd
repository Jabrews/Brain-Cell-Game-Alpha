extends Node

var enabled : bool = true 

var admin_panel_root : AdminPanelRoot
# per batch
var updater_admin_batch_mutation : AdminBatchMutation
# per event
var updater_random_mutation_event : AdminRandomMutationEvent # not too sure why random is in the name
var updater_defect_event : AdminDefectEvent

# when save = false we dont save into json log
var save_updater_admin_batch_mutation : bool = false 
var save_random_mutation_event : bool = false
var save_defect_event : bool = true 
