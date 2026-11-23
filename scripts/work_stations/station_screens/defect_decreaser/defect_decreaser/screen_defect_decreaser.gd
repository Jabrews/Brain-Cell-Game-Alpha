extends Node

# parent components
@onready var stats_parent : Control = $Stats
@onready var place_cell_parent : Control = $PlaceCell
@onready var disabled_parent : Control = $Disabled
@onready var no_defect_to_decrease_parent : Control = $NoDefectToDecrease
@onready var success_parent : Control = $SuccessParent
# stats components
@onready var clean_bars : Array[TextureRect] = [
	$Stats/Strength/CleanBar, $Stats/Intelligence/CleanBar, $Stats/Community/CleanBar
]
@onready var defect_bars : Array[TextureRect] = [
	$Stats/Strength/DefectBar, $Stats/Intelligence/DefectBar, $Stats/Community/DefectBar
]
@onready var hidden_sprites : Array[Sprite2D] = [
	$Stats/Strength/HiddenSprite, $Stats/Intelligence/HiddenSprite, $Stats/Community/HiddenSprite
]
@onready var disabled_parents : Array[Control] = [
	$Stats/Strength/Disabled, $Stats/Intelligence/Disabled, $Stats/Community/Disabled
]

func _ready() -> void:
	
	for clean_bar in clean_bars : 
		clean_bar.material = clean_bar.material.duplicate()
		
	for defect_bar in defect_bars : 
		defect_bar.material = defect_bar.material.duplicate()
	
	GLDefectDecreaserComponentBus.connect('display_success', _handle_display_success)


func _refresh(enabled : bool, defect_reduction_context : DefectReductionContext) :
	
	# reset parents
	stats_parent.visible = false
	place_cell_parent.visible = false
	disabled_parent.visible = false
	no_defect_to_decrease_parent.visible = false
	
	if not enabled : 
		disabled_parent.visible = true
		return
	
	if enabled and not defect_reduction_context: 
		place_cell_parent.visible = true
		return
	
	if enabled and not defect_reduction_context.valid : 
		no_defect_to_decrease_parent.visible = true
		return
	
	
	stats_parent.visible = true
	
	var cell_stats : Array[BrainCellStat] = defect_reduction_context.loaded_cell._get_stats()
	
	# loop through stats and set correct inital data
	for stat in cell_stats : 
		
		var stat_index : int = cell_stats.find(stat)		
		
		# get components for stat
		var clean_bar : TextureRect = clean_bars[stat_index]
		var defect_bar : TextureRect = defect_bars[stat_index]	
		var hidden_sprite : Sprite2D = hidden_sprites[stat_index]
		var disabled_indv_parent : Control = disabled_parents[stat_index] 
		
		# reset bar values
		clean_bar.material.set_shader_parameter('progress', 0.0)
		defect_bar.material.set_shader_parameter('progress', 0.0)
		defect_bar.material.set_shader_parameter('new_value', 0.0)
		
		if not stat.enabled : 
			disabled_indv_parent.visible = true
			return
		
		if stat.hidden : 
			hidden_sprite.visible = true
			return
		
		# set stats
		var max_value : float = IVCellCreator.max_stat_value
		
		clean_bar.material.set_shader_parameter('progress', stat.value / max_value)
		defect_bar.material.set_shader_parameter('progress', stat.defect / max_value)
		defect_bar.material.set_shader_parameter(
			"new_value",
			maxf(stat.defect - IVDefectDecreaser.decrease_amount, 0.0) / max_value
		)		
		
func _handle_display_success() :
	success_parent.visible = true
	await get_tree().create_timer(1.0).timeout	
	success_parent.visible = false 
