
extends Node

# display componnets
@onready var mutation_sprite : Sprite2D = $MutationSprite
@onready var mutation_type_label : Label = $MutationType

# helper componnets
@onready var get_mutation_symbol : Node = $GetMutationSymbol

func _load_mutation(mutation: BrainCellMutation) -> void:
	mutation_sprite.texture = get_mutation_symbol.get_symbol(mutation.type)
	
	mutation_type_label.text = str(mutation.type)	
	
	
