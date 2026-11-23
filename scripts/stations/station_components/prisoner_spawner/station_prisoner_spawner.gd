extends Node

# componnets
@export var prisoners_parent_node : Node
@onready var prisoner_spots : Array[Node3D] = [
	$PrisonerSpawnSpots/Spot1,
	$PrisonerSpawnSpots/Spot2,
	$PrisonerSpawnSpots/Spot3,
	$PrisonerSpawnSpots/Spot4,
]
@onready var prisoner_instance : PackedScene = preload("res://scenes/characters/prisoner/prisoner.tscn")
@onready var screen_pick_quanity : Node2D = $MaxPickQuanityTV/TvFrontPannel/SubViewport/ScreenPickQuanity
@onready var screen_alteration_info : Node2D = $AlterationInfo/TvFrontPannel/SubViewport/ScreenAlterationInfo

func _ready() -> void:
	GLPrisonerSpawnerBus.connect('get_newest_prisoner_cells', _handle_get_newest_prisoner_cells)
	GLCellManagerBus.connect('prisoner_picked_by_player', _handle_prisoner_picked_by_player)
	
func _handle_get_newest_prisoner_cells(new_prisoner_cells : Array[BrainCell], prisoner_offer_card : PrisonerOfferCard) :
	
	# update prisoner picks	
	screen_pick_quanity._update()
	screen_alteration_info._update(prisoner_offer_card)
	
	# reset all seats 
	for spot in prisoner_spots:
		spot.is_being_sat_in = false
	
	
	for cell : BrainCell in new_prisoner_cells :
		create_cell_instance(cell)
	
	

func create_cell_instance(designated_brain_cell : BrainCell) -> void:

	var prisoner = prisoner_instance.instantiate()
	prisoner.designated_brain_cell = designated_brain_cell

	prisoners_parent_node.add_child(prisoner)

	for spot in prisoner_spots:
		if not spot.is_being_sat_in:

			prisoner.global_position = spot.global_position
			spot.is_being_sat_in = true

			return

	push_error("No available prisoner spots")
	prisoner.queue_free()
	
	
func _handle_prisoner_picked_by_player(_prisoner_cell : BrainCell) :
	GLPrisonerPicks.prisoners_to_pick -= 1	
	screen_pick_quanity._update()
	
	if GLPrisonerPicks.prisoners_to_pick <= 0 :
		GLCellManagerBus.emit_signal('delete_remaining_prisoners')
		screen_alteration_info._turn_off()
		

	
	
	
