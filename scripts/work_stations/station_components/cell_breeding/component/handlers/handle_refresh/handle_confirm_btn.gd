extends Node

@onready var confirm_btn: Control = $"../../BreedingUI/InteractFooter/ConfirmBtn"

var main_cells_missing_text: String = "Missing main breeding cells on station panels"
var main_cells_unavaible_text: String = "One or Both main breeding cells are unavaible to breed this turn"
var stat_diffrence_text: String = "Station's Panels do not align with UI"


func _handle() -> void:
	
	var panel_state: Dictionary[String, BrainCell] = (
		GLBreedingComponetsBus.breeding_panel_state.duplicate()
	)
	
	var ui_state: Dictionary[String, BrainCell] = (
		GLBreedingComponetsBus.breeding_ui_state.duplicate()
	)
	
	var left_panel_cell: BrainCell = panel_state["left_main"]
	var right_panel_cell: BrainCell = panel_state["right_main"]
	
	var has_main_cells: bool = (
		left_panel_cell != null
		and right_panel_cell != null
	)
	
	# panel and UI must match
	_set_invalid_reason(
		stat_diffrence_text,
		panel_state != ui_state
	)
	
	# both main cells must exist
	_set_invalid_reason(
		main_cells_missing_text,
		not has_main_cells
	)
	
	# main cells must be available
	var main_cells_unavailable: bool = false
	
	if has_main_cells:
		main_cells_unavailable = (
			left_panel_cell.breeder_unavaible
			or right_panel_cell.breeder_unavaible
		)
	
	_set_invalid_reason(
		main_cells_unavaible_text,
		main_cells_unavailable
	)
	
	_sort_invalid_reasons()
	
	# confirm is valid only when there are no invalid reasons
	var confirm_valid: bool = (
		GLBreedingComponetsBus.reasons_confirm_invalid.is_empty()
	)
	
	confirm_btn._toggle_confirm_available(confirm_valid)


func _set_invalid_reason(reason: String, invalid: bool) -> void:
	
	if invalid:
		if not GLBreedingComponetsBus.reasons_confirm_invalid.has(reason):
			GLBreedingComponetsBus.reasons_confirm_invalid.append(reason)
	else:
		GLBreedingComponetsBus.reasons_confirm_invalid.erase(reason)


func _sort_invalid_reasons() -> void:
	
	var priority: Array[String] = [
		main_cells_missing_text,
		stat_diffrence_text,
		main_cells_unavaible_text
	]
	
	GLBreedingComponetsBus.reasons_confirm_invalid.sort_custom(
		func(a: String, b: String) -> bool:
			return priority.find(a) < priority.find(b)
	)
