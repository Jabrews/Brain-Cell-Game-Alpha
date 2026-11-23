extends Node

# components
@onready var hidden_parent : Control = $Hidden
@onready var mutation_name_label : Label = $MutationName
@onready var mutation_icon : TextureRect = $MutationIcon

# helper component
@onready var get_mutation_symbol : Node = $GetMutationSymbol

var is_hidden : bool = false

func _load_mutation(mutation : BrainCellMutation): 
	
	if mutation.hidden : 	
		is_hidden = true
		hidden_parent.visible = true
		mutation_name_label.text = 'hidden'
		return
	
	mutation_name_label.text = mutation.type
	mutation_icon.texture = get_mutation_symbol.get_symbol(mutation.type)
	
	
	
	
		
		
		

	
