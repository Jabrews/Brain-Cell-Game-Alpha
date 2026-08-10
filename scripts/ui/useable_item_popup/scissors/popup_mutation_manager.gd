extends Node

@onready var mutation_card_1 : Control = $MutationCard1
@onready var mutation_card_2 : Control =$MutationCard2
@onready var mutation_card_3 : Control = $MutationCard3

func _init_mutations(mutations: Array[BrainCellMutation]) -> void:
	if mutations.size() > 0:
		mutation_card_1.visible = true
		mutation_card_1._load_mutation(mutations[0])
	else :
		mutation_card_1.visible = false

	if mutations.size() > 1:
		mutation_card_2.visible = true
		mutation_card_2._load_mutation(mutations[1])
	else :
		mutation_card_2.visible = false	

	if mutations.size() > 2:
		mutation_card_3	.visible = true
		mutation_card_3._load_mutation(mutations[2])
	else :
		mutation_card_3.visible = false	
