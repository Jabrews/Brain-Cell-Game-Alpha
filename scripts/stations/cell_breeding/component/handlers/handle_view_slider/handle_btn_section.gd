extends Node

# components
@onready var view_btn_section : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/ViewBtnSection"
@onready var unloaded_hint : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/BtnUnloadedHint"
@onready var btn_parent : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/ViewBtnSection/BtnParent"

# handle components
@onready var handle_information_section : Node = $"../HandleInformationSection"

var active_info_section_type : String = 'stats'


func _toggle_active(toggle_value : bool) :
	
	if toggle_value : 
		view_btn_section.modulate.a = 1.0
		unloaded_hint.visible = false 
		
		# starts on stats
		btn_parent.get_children()[0]._handle_btn_pressed(true) # skip btn dow
		
		
	else :
		view_btn_section.modulate.a = 0.15
		unloaded_hint.visible = true 
		
		for btn : Control in btn_parent.get_children() : 	
			btn._clear_btn()


func _handle_btn_pressed(info_section_type: String, btn_text : String) :
	
	active_info_section_type = info_section_type 
	
	for btn : Control in btn_parent.get_children() : 	
		
		if btn.info_section_type == active_info_section_type:
			continue
		else :
			btn._clear_btn()
	
	handle_information_section._load_info_section_type(active_info_section_type, btn_text)
