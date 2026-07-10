extends Node


# display componnetns
@onready var hidden_parent : Control = $Hidden
@onready var mutation_parent : Control = $MutationDisplay

# mutation parent componnets 
@onready var display_type_label : Label = $MutationDisplay/DisplayType
@onready var place_holder_icon_rect : ColorRect = $MutationDisplay/PlaceHolderIcon



func _handle_brain_cell_recieved(cell_mutation : BrainCellMutation) -> void:
	
	if cell_mutation and cell_mutation.hidden : 
		mutation_hidden()
		return
	
	if cell_mutation and not cell_mutation.hidden : 
		display_mutation(cell_mutation)
		return
	
	
	
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
	place_holder_icon_rect.color = Color.BLUE
#	
	
