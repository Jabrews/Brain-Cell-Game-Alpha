extends Node

# components
@onready var unloaded_hint : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationUnloadedHint"
@onready var information_section : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection"
@onready var information_type_label : Label = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/InformationTypeLabel"

func _toggle_active(toggle_value : bool) :
	
	if toggle_value : 
		unloaded_hint.visible = false
		information_section.modulate.a = 1.0
	
	else :
		unloaded_hint.visible = true 
		information_type_label.text = 'none'
		information_section.modulate.a = 0.15

func _load_info_section_type(active_info_section_type : String, btn_text : String) :
	information_type_label.text = btn_text
	
	
	
