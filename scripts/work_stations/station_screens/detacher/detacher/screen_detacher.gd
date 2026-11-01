extends Node

## parent components
@onready var disabled_stat_parent : Control = $Disabled
@onready var add_a_cell_parent : Control = $AddACell
@onready var stats_parent : Control = $Stats


## stat display
# label components
@onready var valid_label : Label = $Stats/ValidityLabels/Valid
@onready var invalid_label : Label = $Stats/ValidityLabels/Invalid
@onready var cell_name_label : Label = $Stats/CellNameHeader/CellNameLabel
# stats
@onready var bar_sprites : Array[Sprite2D] = [
	$Stats/Strength/Bar, $Stats/Intelligence/Bar, $Stats/Community/Bar
]
@onready var defect_bars :Array [TextureProgressBar] = [
	$Stats/Strength/DefectBar, $Stats/Intelligence/DefectBar, $Stats/Community/DefectBar
]
@onready var disabled_parents : Array[Control] = [
	$Stats/Strength/DisabledParent, $Stats/Intelligence/DisabledParent, $Stats/Community/DisabledParent
]
@onready var hidden_parents : Array[Control] = [
	$Stats/Strength/HiddenParent, $Stats/Intelligence/HiddenParent, $Stats/Community/HiddenParent
]
@onready var active_borders : Array[TextureRect] = [
	$Stats/Strength/ActiveBorder, $Stats/Intelligence/ActiveBorder, $Stats/Community/ActiveBorder
]

func _refresh(
	enabled : bool,
	loaded_cell : BrainCell,
	stat_selected_index : int, 	
	stat_valid : bool,
) :
	disabled_stat_parent.visible = false
	add_a_cell_parent.visible = false
	stats_parent.visible = false
	
	if not enabled : 
		disabled_stat_parent.visible = true
		return
	
	if not loaded_cell : 
		add_a_cell_parent.visible = true
		return
	
	else : 	
		
		stats_parent.visible = true
		
		display_stats(loaded_cell)
		
		valid_label.visible = stat_valid		
		invalid_label.visible = !stat_valid		
		
		cell_name_label.text = loaded_cell.name
		
		for active_border : TextureRect in active_borders : 
			active_border.visible = false
			
		if stat_selected_index != -1: 
			active_borders[stat_selected_index].visible = true

func display_stats(loaded_cell : BrainCell): 

	var stats : Array[String] = ['strength', 'intelligence', 'community']		
	
	var curr_index = 0		
	
	while curr_index < len(stats) : 
		
		var stat_type : String = stats[curr_index]
		var stat : BrainCellStat = loaded_cell.get_stat(stat_type)
		var bar_sprite : Sprite2D = bar_sprites[curr_index]
		var defect_bar : TextureProgressBar = defect_bars[curr_index]
		var disabled_parent : Control = disabled_parents[curr_index]
		var hidden_parent : Control = disabled_parents[curr_index]
	
		disabled_parent.visible = false
		hidden_parent.visible = false
		
		if not stat.enabled : 
			disabled_parent.visible = true
			curr_index += 1		
			return
		
		if stat.hidden : 
			hidden_parent.visible = true
			curr_index += 1		
			return
		
		var max_stat_value : float = IVCellCreator.max_stat_value
		
		bar_sprite.material.set_shader_parameter("prisoner_value", stat.value / max_stat_value)
		
		defect_bar.max_value = max_stat_value
		defect_bar.value = stat.defect
		
		curr_index += 1		
		
		
		
		
			
		
			
			
		
		
