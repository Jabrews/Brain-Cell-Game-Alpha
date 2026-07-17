extends Node

@onready var mutation_found_label : Label = $MutationFound
@onready var no_mutation_found_label : Label = $NoMutationFound

func _ready() -> void:
	GLPrisonerSpawnerBus.connect('apply_mutations_all_hidden', _handle_apply_mutations_all_hidden)
	GLPrisonerSpawnerBus.connect('apply_mutation_regular', _handle_apply_mutation_regular)
	GLCellManagerBus.connect('delete_remaining_prisoners', _handle_delete_remaining_prisoners)
	
func _handle_delete_remaining_prisoners() : 
	no_mutation_found_label.visible = true 
	mutation_found_label._display(false)
	mutation_found_label.visible = false
	

func _handle_apply_mutations_all_hidden() :
	no_mutation_found_label.visible = false 
	mutation_found_label._display(true)
	mutation_found_label.visible = true

func _handle_apply_mutation_regular(_mutation_amount : int) :
	no_mutation_found_label.visible = false 
	mutation_found_label._display(true)
	mutation_found_label.visible = true
