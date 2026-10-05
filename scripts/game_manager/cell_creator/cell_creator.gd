extends Node

# components
@onready var cell_manager : Node = $"../CellManager"
@onready var assemble_cells : Node = $AssembleCells

var current_cell_constructor : CellConstructor


func _ready() -> void:
	connect_signals()


func connect_signals() -> void:
	GLCellCreatorBus.connect(
		"create_prisoner_cells",
		handle_create_prisoners
	)


# signal create_prisoner_cells(cell_constructor : CellConstructor)
func handle_create_prisoners( cell_constructor : CellConstructor) -> void:
	
	current_cell_constructor = cell_constructor
	
	GLGameManagerBus.emit_signal('proceed_next_turn')	
	
	# decide prisoner picks quanity			
	GLPrisonerPicks.prisoners_to_pick = cell_constructor.prisoner_picks
			
			
	GLCellManagerBus.emit_signal('delete_remaining_prisoners')

	var new_prisoner_cells : Array[BrainCell] = assemble_cells.assemble(cell_constructor)
	
	# shuffle cells
	new_prisoner_cells.shuffle()
	
	
	cell_manager.set_prisoner_cells(
		new_prisoner_cells
	)
	

	GLCellCreatorBus.emit_signal(
		"get_newest_prisoner_cells",
		new_prisoner_cells
	)
