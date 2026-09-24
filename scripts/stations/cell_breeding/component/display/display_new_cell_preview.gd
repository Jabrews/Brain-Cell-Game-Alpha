extends Node

# components
@onready var parent_new_cell_display : Control = $"../BreedingUI/NewCellDisplay"
@onready var parent_cell_loader_display : Control = $"../BreedingUI/CellLoader"
@onready var interact_footer : Control = $"../BreedingUI/InteractFooter"
@onready var handle_confirm_btn : Node = $"../HandleConfirmBtn"

# visual components
@onready var progress_bars : Array[Sprite2D] = [
	$"../BreedingUI/NewCellDisplay/NewCell/ProgressBars/StrengthBar", 
	$"../BreedingUI/NewCellDisplay/NewCell/ProgressBars/IntelligenceBar", 
	$"../BreedingUI/NewCellDisplay/NewCell/ProgressBars/CommunityBar"
]

@onready var defect_bars : Array[Sprite2D] = [
	$"../BreedingUI/NewCellDisplay/NewCell/DefectBars/StrengthDefect",
	$"../BreedingUI/NewCellDisplay/NewCell/DefectBars/IntelligenceDefect",
	$"../BreedingUI/NewCellDisplay/NewCell/DefectBars/CommunityDefect"
]

@onready var off_display_labels : Array[Label] = [
	$"../BreedingUI/NewCellDisplay/NewCell/OffDisableLabels/StrengthOffLabel", 
	$"../BreedingUI/NewCellDisplay/NewCell/OffDisableLabels/IntelligenceOffLabel", 
	$"../BreedingUI/NewCellDisplay/NewCell/OffDisableLabels/CommunityOffLabel"
]

@onready var hide_stat_sprites : Array[Sprite2D] = [
	$"../BreedingUI/NewCellDisplay/NewCell/HideStats/StrengthHide", 
	$"../BreedingUI/NewCellDisplay/NewCell/HideStats/IntelligenceHide", 
	$"../BreedingUI/NewCellDisplay/NewCell/HideStats/CommunityHide"
]


var stat_types : Array[String] = [
	"strength",
	"intelligence",
	"community"
]

# preview-only cells
var preview_left_cell : BrainCell
var preview_right_cell : BrainCell
var preview_new_cell : BrainCell


func _ready() -> void:
	
	for bar : Sprite2D in progress_bars:
		bar.material = bar.material.duplicate()
	
	for bar : Sprite2D in defect_bars:
		bar.material = bar.material.duplicate()


func _display() -> void:
	
	var left_cell : BrainCell = (
		GLBreedingComponetsBus.breeding_panel_state["left_main"]
	)
	
	var right_cell : BrainCell = (
		GLBreedingComponetsBus.breeding_panel_state["right_main"]
	)
	
	if not left_cell or not right_cell:
		return
	
	
	# make copies so real cell state is never changed
	preview_left_cell = left_cell.copy()
	preview_right_cell = right_cell.copy()
	
	
	# apply left boost to copy
	preview_left_cell = apply_charge_boost_to_copy(
		preview_left_cell,
		GLBreedingComponetsBus.left_boost_stat,
		GLBreedingComponetsBus.left_boost_direction
	)
	
	
	# apply right boost to copy
	preview_right_cell = apply_charge_boost_to_copy(
		preview_right_cell,
		GLBreedingComponetsBus.right_boost_stat,
		GLBreedingComponetsBus.right_boost_direction
	)
	
	
	# simulate bred cell using boosted copies
	preview_new_cell = GAMECellBreeder._handle_player_simulate_breeded_cells(
		preview_left_cell,
		preview_right_cell
	)
	
	if not preview_new_cell:
		return
	
	
	parent_cell_loader_display.visible = false
	parent_new_cell_display.visible = true
	
	interact_footer._toggle_new_cell_preview(true)
	
	
	_display_cell_visuals(preview_new_cell)


func apply_charge_boost_to_copy(
	cell : BrainCell,
	energy_boost_stat : String,
	energy_boost_direction : String
) -> BrainCell:
	
	if not cell:
		return null
	
	if energy_boost_stat == "none":
		return cell
	
	if energy_boost_direction == "none":
		return cell
	
	return GAMECellBreeder.increase_cell_charge_helper._get_increased(
		energy_boost_stat,
		energy_boost_direction,
		cell
	)


func _display_cell_visuals(cell : BrainCell) -> void:
	
	if not cell:
		return
	
	for stat_index : int in stat_types.size():
		
		var stat_type : String = stat_types[stat_index]
		
		var new_stat : BrainCellStat = cell.get_stat(stat_type)
		var left_stat : BrainCellStat = preview_left_cell.get_stat(stat_type)
		var right_stat : BrainCellStat = preview_right_cell.get_stat(stat_type)
		
		var progress_bar : Sprite2D = progress_bars[stat_index]
		var defect_bar : Sprite2D = defect_bars[stat_index]
		var off_label : Label = off_display_labels[stat_index]
		var hidden_sprite : Sprite2D = hide_stat_sprites[stat_index]
		
		
		# stat is only disabled if BOTH parents have it disabled
		var stat_disabled : bool = (
			not left_stat.enabled
			and not right_stat.enabled
		)
		
		off_label.visible = stat_disabled
		
		progress_bar.visible = not stat_disabled
		defect_bar.visible = not stat_disabled
		
		if stat_disabled:
			hidden_sprite.visible = false
			continue
		
		
		# hidden if either parent or resulting cell has hidden stat
		var stat_hidden : bool = (
			left_stat.hidden
			or right_stat.hidden
			or new_stat.hidden
		)
		
		hidden_sprite.visible = stat_hidden
		
		if stat_hidden:
			progress_bar.visible = false
			defect_bar.visible = false
			continue
		
		
		_display_clean_bar(
			progress_bar,
			new_stat,
			left_stat,
			right_stat
		)
		
		_display_defect_bar(
			defect_bar,
			new_stat,
			left_stat,
			right_stat
		)


func _display_clean_bar(
	bar : Sprite2D,
	new_stat : BrainCellStat,
	left_stat : BrainCellStat,
	right_stat : BrainCellStat
) -> void:
	
	var max_value : float = float(
		IVCellCreator.max_stat_value
	)
	
	if max_value <= 0.0:
		return
	
	
	var start_value : float = _get_highest_enabled_value(
		left_stat,
		right_stat,
		"value"
	)
	
	
	# resulting bred value
	bar.material.set_shader_parameter(
		"prisoner_value",
		clampf(
			new_stat.value / max_value,
			0.0,
			1.0
		)
	)
	
	
	# highest enabled parent value
	bar.material.set_shader_parameter(
		"start_value",
		clampf(
			start_value / max_value,
			0.0,
			1.0
		)
	)


func _display_defect_bar(
	bar : Sprite2D,
	new_stat : BrainCellStat,
	left_stat : BrainCellStat,
	right_stat : BrainCellStat
) -> void:
	
	var max_value : float = float(
		IVCellCreator.max_stat_value
	)
	
	if max_value <= 0.0:
		return
	
	
	var start_value : float = _get_highest_enabled_value(
		left_stat,
		right_stat,
		"defect"
	)
	
	
	# resulting bred defect
	bar.material.set_shader_parameter(
		"stat_defect_value",
		clampf(
			new_stat.defect / max_value,
			0.0,
			1.0
		)
	)
	
	
	# highest enabled parent defect
	bar.material.set_shader_parameter(
		"start_value",
		clampf(
			start_value / max_value,
			0.0,
			1.0
		)
	)


func _get_highest_enabled_value(
	stat_1 : BrainCellStat,
	stat_2 : BrainCellStat,
	value_type : String
) -> float:
	
	if stat_1.enabled and stat_2.enabled:
		return max(
			_get_stat_value(stat_1, value_type),
			_get_stat_value(stat_2, value_type)
		)
	
	if stat_1.enabled:
		return _get_stat_value(
			stat_1,
			value_type
		)
	
	if stat_2.enabled:
		return _get_stat_value(
			stat_2,
			value_type
		)
	
	return 0.0


func _get_stat_value(
	stat : BrainCellStat,
	value_type : String
) -> float:
	
	match value_type:
		
		"value":
			return stat.value
		
		"defect":
			return stat.defect
		
		_:
			push_error(
				"Invalid stat value type: ",
				value_type
			)
			return 0.0


func _close() -> void:
	
	parent_cell_loader_display.visible = true
	parent_new_cell_display.visible = false
	
	interact_footer._toggle_new_cell_preview(false)
	handle_confirm_btn.current_screen = "cell_loader"
