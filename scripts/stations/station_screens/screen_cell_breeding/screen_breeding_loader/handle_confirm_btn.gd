extends Node

# display componnets
@onready var press_to_see_result_label : Label = $"../SeatCellLoading/PressBtnToSeeResult"
@onready var parent_seat_cell_loading : Node2D = $"../SeatCellLoading"
@onready var parent_new_cell_preview : Node2D = $"../NewCellPreview"


# final breeding handler
@onready var helper_finale_breeding_request : Node = $"../../../../../FinalBreedingRequest"

var can_breed : bool = false
var can_look_at_new_cell_display : bool = false
var new_cell_display_shown : bool = false


func _ready() -> void:
	show_loader_display(false)


func _handle_btn_pressed() -> void:
	
	if not can_look_at_new_cell_display:
		return
	
	# First press: loader -> new cell preview
	if not new_cell_display_shown:
		show_new_cell_display()
		return
	
	# Second press: new cell preview -> breed -> loader
	if can_breed:
		initate_breeding()
		show_loader_display(false)


func _cells_detcted(has_both: bool) -> void:
	can_look_at_new_cell_display = has_both 
	
	# If a cell gets removed, always return to loader.
	if not has_both:
		show_loader_display(false)
		return
	
	# If both cells exist and preview is not showing,
	# show loader + label.
	if not new_cell_display_shown:
		show_loader_display(true)


func show_loader_display(show_label: bool) -> void:
	new_cell_display_shown = false
	can_breed = false
	
	parent_seat_cell_loading.visible = true
	parent_new_cell_preview.visible = false
	press_to_see_result_label.visible = show_label


func show_new_cell_display() -> void:
	new_cell_display_shown = true
	can_breed = true
	
	parent_seat_cell_loading.visible = false
	parent_new_cell_preview.visible = true
	press_to_see_result_label.visible = false

func initate_breeding(): 	
	helper_finale_breeding_request._handle_final_breeding_request()
	
