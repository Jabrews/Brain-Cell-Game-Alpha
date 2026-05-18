extends Node

enum HIDDEN_STAT_INTERPRETER_TYPES {
	STRENGTH,
	INTELLIGENCE,
	COMMUNITY
}

@export_enum("strength", "intelligence", "community")
var interpreter_type : String = "strength"

# station state
var active_container : CharacterBody3D


func _handle_panel_body_recieved(container_body : CharacterBody3D) :
	
	if not container_body :
		return
	
	var panel_cell = container_body.designated_brain_cell	
	
	var cell_has_hidden_stat : bool = check_cell_has_hidden_stat(panel_cell)
	
	if cell_has_hidden_stat :
		GLCellManagerBus.emit_signal('hidden_stat_interpreted', panel_cell, interpreter_type)


func check_cell_has_hidden_stat(cell : BrainCell) -> bool:
	
	match interpreter_type :
		'strength' :
			return cell.strength_hidden
		'intelligence' :
			return cell.intelligence_hidden
		'community' :
			return cell.community_hidden
			
	return false
