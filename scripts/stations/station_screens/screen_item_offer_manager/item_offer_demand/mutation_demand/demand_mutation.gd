extends Node

# display components
@onready var mutation_icon_sprite : Sprite2D = $MutationIcon
@onready var mutation_type_label : Label= $MutationType

# helper componnet
@onready var get_mutation_symbol : Node = $GetMutationSymbol


func _load_mutation(mutation : BrainCellMutation) -> void:
	
	mutation_icon_sprite.texture = get_mutation_symbol.get_symbol(mutation.type)
	mutation_type_label.text = str(mutation.type)	
	
	
	
	
	
	
	
