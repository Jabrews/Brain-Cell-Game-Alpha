extends Node

# components
@onready var view_btn_section : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/ViewBtnSection"
@onready var unloaded_hint : Control = $"../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/UnloadedHint"


func _toggle_active(toggle_value : bool) :
	
	if toggle_value : 
		view_btn_section.modulate.a = 1.0
		unloaded_hint.visible = false 
	
	else :
		view_btn_section.modulate.a = 0.15
		unloaded_hint.visible = true 

func _handle_btn_pressed(btn_type : String) :
	pass
