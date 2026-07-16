extends Node


# display componnetns
@onready var hidden_parent : Control = $Hidden
@onready var mutation_parent : Control = $MutationDisplay

# mutation parent componnets 
@onready var display_type_label : Label = $MutationDisplay/DisplayType
#@onready var place_holder_icon_rect : ColorRect = $MutationDisplay/PlaceHolderIcon
@onready var mutation_icon : TextureRect = $MutationDisplay/MutationIcon
@onready var get_mutation_symbol : Node = $GetMutationSymbol



func _handle_mutation_recieved(cell_mutation : BrainCellMutation) -> void:
	
	if not cell_mutation:
		no_mutation_found()
	
	if cell_mutation.type == 'none': 
		mutation_hidden()
		return

	if cell_mutation.hidden:
		mutation_hidden()
	else:
		display_mutation(cell_mutation)
		
	
	
func no_mutation_found() :
	hidden_parent.visible = false
	mutation_parent.visible = false
	
	

func mutation_hidden() :
	hidden_parent.visible = true 
	mutation_parent.visible = false
	
func display_mutation(mutation : BrainCellMutation) :
	hidden_parent.visible = false 
	mutation_parent.visible = true 
	display_type_label.text = mutation.type
	mutation_icon.texture = get_mutation_symbol.get_symbol(mutation.type)
	
	
	
	
#	
	
