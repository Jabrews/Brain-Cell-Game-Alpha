extends Node

var left_brain_cell : BrainCell 
var right_brain_cell : BrainCell

# components
# main displays
@onready var waiting_parent : Control = $WaitingScreen
@onready var breeding_ran_out_parent : Control = $BreedingRanOut
@onready var breeding_attempts_left_label : Label = $BreedinAttemptsLeft
@onready var symbol_parent : Control = $Symbols

## waiting screen main displays
@onready var cell_left_loader : Control = $WaitingScreen/CellLeftLoader
@onready var left_loader_stat_display : Control = $WaitingScreen/CellLeftLoader/StatDisplay
@onready var left_waiting_label : Label = $WaitingScreen/CellLeftLoader/Waiting
@onready var cell_right_loader : Control = $WaitingScreen/CellRightLoader
@onready var right_loader_stat_display : Control = $WaitingScreen/CellRightLoader/StatDisplay
@onready var right_waiting_label : Label = $WaitingScreen/CellRightLoader/Waiting

### OTHER LOGIC
# stat display updater
@onready var stat_display_updater_left : Node = $StatDisplayUpdaterLeft
@onready var stat_display_updater_right : Node = $StatDisplayUpdaterRight
# stat symbol updater
@onready var stat_symbol_updater : Node = $StatSymbolUpdater

func _ready() -> void: 
	# for handling when we run out of breeding attempts
	GLCellBreederBus.connect('player_breeded_cells', _handle_player_breeded_cells)
	
	# update breeding left label
	breeding_attempts_left_label.text = "Breeding Attempts Left : " + str(IVCellBreeding.max_cell_breeding_attempts - IVCellBreeding.curr_cell_breeding_attempt)


# accept cell from left or right
func _handle_breeding_panel_cell_recieved(loaded_cell : BrainCell, panel_side : String) :
	
	if panel_side == 'left' : 
		left_brain_cell = loaded_cell
		stat_display_updater_left._load_breeding_panel_cell(loaded_cell)
		

	if panel_side == 'right' : 
		right_brain_cell = loaded_cell
		stat_display_updater_right._load_breeding_panel_cell(loaded_cell)
	
	# update symbol	
	stat_symbol_updater._load_breeding_panel_cell(panel_side, loaded_cell)
	
	# also update the indiv stat display updater
	update_display() 	
	
	
func update_display():
	
	var has_left  = left_brain_cell != null
	var has_right = right_brain_cell != null
	
	# left side
	left_loader_stat_display.visible = has_left
	left_waiting_label.visible = not has_left
	
	# right side
	right_loader_stat_display.visible = has_right
	right_waiting_label.visible = not has_right
	
	


func _handle_player_breeded_cells(_cell_1, _cell_2) : 
	# check if theres any attempts left
	if IVCellBreeding.curr_cell_breeding_attempt >= IVCellBreeding.max_cell_breeding_attempts :
		breeding_ran_out_parent.visible = true		
		waiting_parent.visible = false 
		symbol_parent.visible = false
	else :
		breeding_ran_out_parent.visible = false 
		waiting_parent.visible = true 
		symbol_parent.visible = true
		breeding_attempts_left_label.text = "Breeding Attempts Left : " + str(IVCellBreeding.max_cell_breeding_attempts - IVCellBreeding.curr_cell_breeding_attempt)
	
		
func _handle_next_round() :
		breeding_ran_out_parent.visible = false 
		waiting_parent.visible = true 
		symbol_parent.visible = true
		breeding_attempts_left_label.text = "Breeding Attempts Left : " + str(IVCellBreeding.max_cell_breeding_attempts - IVCellBreeding.curr_cell_breeding_attempt)
	
	
