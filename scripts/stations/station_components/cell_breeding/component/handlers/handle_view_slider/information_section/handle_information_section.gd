extends Node

# components
@onready var unloaded_hint : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationUnloadedHint"
@onready var information_section : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection"
@onready var information_type_label : Label = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/InformationTypeLabel"

# information components
@onready var info_stats : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats"
@onready var info_blood_type : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/BloodType"
@onready var info_failure_chance : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/FailureChance"
@onready var info_mutations : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/InformationMutations"

# display components
@onready var display_stats : Node = $DisplayStats
@onready var display_failure_chance : Node = $DisplayFailureChance
@onready var display_mutations : Node = $DisplayMutations


func _toggle_active(toggle_value : bool) :
	
	if toggle_value : 
		unloaded_hint.visible = false
		information_section.modulate.a = 1.0
	
	else :
		unloaded_hint.visible = true 
		information_type_label.text = 'none'
		information_section.modulate.a = 0.15
		reset_info()

func _load_info_section_type(active_info_section_type : String, btn_text : String) :
	information_type_label.text = btn_text
	
	reset_info()
	
	match active_info_section_type : 	
		'stats' : 
			info_stats.visible = true
		'failure_chance' : 
			info_failure_chance.visible = true
		'blood_type' : 
			info_blood_type.visible = true
		'mutations' : 
			info_mutations.visible = true

func reset_info(): 
	info_stats.visible = false
	info_blood_type.visible = false
	info_failure_chance.visible = false
	info_mutations.visible = false

func _display_information_section(cell : BrainCell) : 
	display_stats._display(cell)
	display_failure_chance._display(cell)
	display_mutations._display(cell)
	
	
	
	
	
