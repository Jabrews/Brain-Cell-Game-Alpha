extends Node

@export_enum(
	"none",
	"airborne",
	"sentient",
	"lonley",
	"disrupter",
	"exsplosive",
	"cognisance",
	"telekinetic"
)
var mutation_one: String = "none"

@export_enum(
	"none",
	"airborne",
	"sentient",
	"lonley",
	"disrupter",
	"exsplosive",
	"cognisance",
	"telekinetic"
)
var mutation_two: String = "none"

@export_enum(
	"none",
	"airborne",
	"sentient",
	"lonley",
	"disrupter",
	"exsplosive",
	"cognisance",
	"telekinetic"
)
var mutation_three: String = "none"

@onready var brain_cell_container_p_s : PackedScene = preload("res://scenes/characters/cell_container/cell_container.tscn")
@onready var spawn_pos : Node3D = $SpawnPos


var all_mutations: Array[BrainCellMutation] = [
	BrainCellMutation.new("airborne", false, [
		MutationEvent.new("airborne_fly", "random_event", "airborne", 0)
	]),

	BrainCellMutation.new("sentient", false, [
		MutationEvent.new("sentient_talk", "constant", "sentient", 0)
	]),

	BrainCellMutation.new("lonley", false, [
		MutationEvent.new("lonley_starvation", "constant", "lonley", 0)
	]),

	BrainCellMutation.new("disrupter", false, [
		MutationEvent.new("disrupter_disrupt", "random_event", "disrupter", 0)
	]),

	BrainCellMutation.new("exsplosive", false, [
		MutationEvent.new("exsplosive_exsplode", "constant", "exsplosive", 0)
	]),

	BrainCellMutation.new("cognisance", false, [
		MutationEvent.new("cognisance_stalk", "constant", "cognisance", 0)
	]),

	BrainCellMutation.new("telekinetic", false, [
		MutationEvent.new("telekinetic_shoot", "random_event", "telekinetic", 0)
	]),
]


func _ready() -> void:
	
	var new_cell: BrainCell = BrainCell.new(
		"test",
		get_mutations(),
		BrainCellStat.new("strength", true, 100, 0, false),
		BrainCellStat.new("intelligence", true, 100, 0, false),
		BrainCellStat.new("community", true, 100, 0, false),
		3,
		false,
		false,
		false,
	)
	
	await get_tree().create_timer(0.2).timeout
	
	GLCellManagerBus.emit_signal('cell_added_to_collection', new_cell)	
	


func get_mutations() -> Array[BrainCellMutation]:
	var mutation_names: Array[String] = [
		mutation_one,
		mutation_two,
		mutation_three
	]

	var mutations_to_add: Array[BrainCellMutation] = []

	for mutation_name: String in mutation_names:
		if mutation_name == "none":
			continue

		for mutation: BrainCellMutation in all_mutations:
			if mutation.type == mutation_name:
				mutations_to_add.append(mutation)
				break

	return mutations_to_add
