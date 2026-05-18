extends Node2D


var active_target_cell : BrainCell
var finale_round_active : bool = false

## components
####################
# name label
@onready var target_name_label : Label = $StatDisplay/TargetName
# bar
@onready var strength_bar : TextureProgressBar = $StatDisplay/ProgressBars/Strength/StrengthBar
@onready var intelligence_bar : TextureProgressBar = $StatDisplay/ProgressBars/Intelligence/IntelligenceBar
@onready var community_bar : TextureProgressBar = $StatDisplay/ProgressBars/Community/CommunityBar
# bar max label 
@onready var large_labels : Array[Label] = [
	$StatDisplay/ProgressLabels/Strength/LargeLabel,
	$StatDisplay/ProgressLabels/Intelligence/LargeLabel2,
	$StatDisplay/ProgressLabels/Community/LargeLabel3
]
# bar value labels 
@onready var curr_value_labels : Array[Label] = [
	$StatDisplay/ProgressBars/Strength/StrengthCurrLabel,	
	$StatDisplay/ProgressBars/Intelligence/IntelligenceCurrLabel,
	$StatDisplay/ProgressBars/Community/CommunityCurrLabel,
]

func _ready() -> void:
	GLCellManagerBus.connect('debug_collected_cells_and_target_create', _on_debug_collected_cells_and_target_create)
	
func _on_debug_collected_cells_and_target_create(_collected_cells : Array[BrainCell], target_cell : BrainCell) : 
	
	# set name
	
	print(target_cell)

	update_display_labels(target_cell)
	update_bar_max()
	update_bar_value(target_cell)
	
	active_target_cell = target_cell
	
	
func update_bar_max() :
	# update progress bars max vs min
	strength_bar.max_value = 160
	intelligence_bar.max_value = 160
	community_bar.max_value = 160


func update_bar_value(target_cell : BrainCell) :
	# set progress bars	
	strength_bar.value = target_cell.strength
	intelligence_bar.value = target_cell.intelligence
	community_bar.value = target_cell.community

func update_display_labels(target_brain_cell : BrainCell) :
	for label in large_labels :
		label.text = str(20)
		
	# strength
	curr_value_labels[0].text = str(target_brain_cell.strength)
	curr_value_labels[1].text = str(target_brain_cell.intelligence)
	curr_value_labels[2].text = str(target_brain_cell.community)
	
