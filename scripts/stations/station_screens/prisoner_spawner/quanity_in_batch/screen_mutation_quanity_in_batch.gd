extends Node


@onready var total_mutation_label : Label = $TotalMutationInBatch
@onready var quanity_num_label : Label = $MutationQuanityNum
@onready var quanity_unknown_label : Label = $MutationQuanityUnknown

func _ready() -> void:
	GLPrisonerSpawnerBus.connect('apply_mutations_all_hidden', _handle_apply_mutations_all_hidden)
	GLPrisonerSpawnerBus.connect('apply_mutation_regular', _handle_apply_mutation_regular)
	GLCellManagerBus.connect('delete_remaining_prisoners', _handle_delete_remaining_prisoners)
	
func _handle_delete_remaining_prisoners() : 
	total_mutation_label.visible = false
	quanity_num_label.visible = false
	quanity_unknown_label.visible = false

func _handle_apply_mutations_all_hidden() :
	total_mutation_label.visible = true 
	quanity_num_label.visible = false
	quanity_unknown_label.visible = true 

func _handle_apply_mutation_regular(mutation_amount : int) :
	total_mutation_label.visible = true 
	quanity_num_label.visible = true
	quanity_num_label.text = str(mutation_amount)
	quanity_unknown_label.visible = false 
