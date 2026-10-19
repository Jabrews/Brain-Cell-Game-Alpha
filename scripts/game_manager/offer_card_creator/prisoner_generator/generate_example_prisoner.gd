extends Node

const GROUP_NAME: StringName = &"generate_example_prisoner"

# creation methods
@onready var default_prisoner_create: Node = $"../CreationMethods/DefaultPrisonerCreate"

func _ready() -> void:
	add_to_group(GROUP_NAME)


func _generate(prisoner_card: PrisonerOfferCard) -> BrainCell:
	
	if prisoner_card.alteration == '' : 
		return default_prisoner_create._create(prisoner_card)
	else : 
		match prisoner_card.alteration : 
			"exsplosive":
				return default_prisoner_create._create(prisoner_card)
			_ : 
				push_error('unable to generate prisoner via alteration : ', prisoner_card.alteration )
				return null
			
	
