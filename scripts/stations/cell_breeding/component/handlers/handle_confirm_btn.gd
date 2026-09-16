extends Node

@onready var confirm_btn: Control = $"../../BreedingUI/InteractFooter/ConfirmBtn"

var main_cells_missing_text: String = "Missing main breeding cells on station panels"
var main_cells_unavaible_text: String = "One or Both main breeding cells are unavaible to breed this turn"


func _handle() -> void:
	
	var panel_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_panel_state.duplicate()
	
	var left_panel_cell: BrainCell = panel_state["left_main"]
	var right_panel_cell: BrainCell = panel_state["right_main"]
	
	
	# check if both main cells exist
	if left_panel_cell and right_panel_cell:
		
		GLBreedingComponetsBus.reasons_confirm_invalid.erase(
			main_cells_missing_text
		)
	
	else:
		
		if not GLBreedingComponetsBus.reasons_confirm_invalid.has(
			main_cells_missing_text
		):
			GLBreedingComponetsBus.reasons_confirm_invalid.append(
				main_cells_missing_text
			)
	
	
	# only check availability if both cells exist
	if left_panel_cell and right_panel_cell:
		
		if left_panel_cell.breeder_unavaible or right_panel_cell.breeder_unavaible:
			
			if not GLBreedingComponetsBus.reasons_confirm_invalid.has(
				main_cells_unavaible_text
			):
				GLBreedingComponetsBus.reasons_confirm_invalid.append(
					main_cells_unavaible_text
				)
		
		else:
			
			GLBreedingComponetsBus.reasons_confirm_invalid.erase(
				main_cells_unavaible_text
			)
	
	else:
		
		GLBreedingComponetsBus.reasons_confirm_invalid.erase(
			main_cells_unavaible_text
		)
	
	
	if left_panel_cell and right_panel_cell : 
		if not left_panel_cell.breeder_unavaible and not right_panel_cell.breeder_unavaible : 
			confirm_btn._toggle_confirm_available(true)
			return
	
	# if not valid
	confirm_btn._toggle_confirm_available(false)
	
	
