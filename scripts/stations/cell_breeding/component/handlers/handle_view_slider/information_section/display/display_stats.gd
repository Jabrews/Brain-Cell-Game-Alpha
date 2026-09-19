extends Node

@onready var stats : Array[String] = ['strength', 'intelligence', 'community']


@onready var clean_bar_sprites : Array[Sprite2D] = [
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats/Strength/CleanBar",
 	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats/Intelligence/CleanBar",
 	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats/Community/CleanBar"	
]
@onready var defect_bars : Array[TextureProgressBar] = [
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats/Strength/DefectBar",
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats/Intelligence/DefectBar",
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats/Community/DefectBar"
]
@onready var hide_sprites : Array[Sprite2D] = [
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats/Strength/HiddenSprite",
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats/Intelligence/HiddenSprite",
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats/Community/HiddenSprite"
]
@onready var off_labels : Array[Label] = [
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats/Strength/OffLabel",
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats/Intelligence/OffLabel",
	$"../../../BreedingUI/CellLoader/SelectedViewSlider/SlideContent/InformationSection/Information/Stats/Community/OffLabel"
]


func _ready() -> void:
	for clean_bar_sprite : Sprite2D in clean_bar_sprites : 
		clean_bar_sprite.material = clean_bar_sprite.material.duplicate()


func _display(cell : BrainCell) :
	
	var index = 0 
	
	while index < stats.size() :
		
		var clean_bar_sprite : Sprite2D = clean_bar_sprites[index]
		var defect_bar : TextureProgressBar = defect_bars[index]
		var hidden_sprite : Sprite2D = hide_sprites[index] 
		var off_label : Label = off_labels[index]
		
		var corrisponding_stat : BrainCellStat = cell.get_stat(stats[index])
		
		
		# hidden
		if corrisponding_stat.hidden : 
			hidden_sprite.visible = true
		else : 
			hidden_sprite.visible = false
		
		
		# enabled
		if not corrisponding_stat.enabled :
			defect_bar.visible = false
			clean_bar_sprite.modulate.a = 0.5
			off_label.visible = true
		else : 
			defect_bar.visible = true 
			clean_bar_sprite.modulate.a = 1.0
			off_label.visible = false 
		
		
		var max_stat_value : float = IVCellCreator.max_stat_value
		
		
		# clean bar
		var prisoner_value : float = 0.0
		
		prisoner_value = corrisponding_stat.value / max_stat_value
		
		clean_bar_sprite.material.set_shader_parameter(
			"prisoner_value",
			prisoner_value
		)
		clean_bar_sprite.material.set_shader_parameter(
			"charge_value",
			prisoner_value
		)
		
		
		# defect bar
		defect_bar.max_value = max_stat_value
		defect_bar.value = corrisponding_stat.defect
		
		
		index += 1
