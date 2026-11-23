
extends Node

# components
@onready var cost_parent: Control = $Cost
@onready var insufficient_parent : Control = $InsufficientParent
@onready var success_parent : Control = $SuccessParent
@onready var total_cost_label: Label = $Cost/CostLabel
@onready var per_stat_cost_label: Label = $Cost/PerStatCostLabel
@onready var background: ColorRect = $Bg

# colors
var enabled_bg_color: Color = Color("#520000")
var disabled_bg_color: Color = Color.BLACK

func _ready() -> void:
	GLDefectDecreaserComponentBus.connect('display_insufficient_funds', _handle_display_insufficient_funds)
	GLDefectDecreaserComponentBus.connect('display_success', _handle_display_success)



func _refresh(enabled: bool, defect_reduction_context: DefectReductionContext) -> void:
	var show_cost: bool = enabled

	# Only check valid stats if a context exists
	if defect_reduction_context:
		show_cost = enabled and not defect_reduction_context.valid_stats.is_empty()

	# Background and visibility
	background.color = enabled_bg_color if show_cost else disabled_bg_color
	cost_parent.visible = show_cost

	if not show_cost:
		return

	# Calculate total cost
	var total_cost: int = 0

	if defect_reduction_context:
		total_cost = (
			IVDefectDecreaser.cost_per_stat
			* defect_reduction_context.valid_stats.size()
		)

	# Update labels
	total_cost_label.text = "-" + str(total_cost)
	per_stat_cost_label.text = str(IVDefectDecreaser.cost_per_stat) + " scraps per stat"
	
func _handle_display_insufficient_funds() :
	insufficient_parent.visible = true
	await get_tree().create_timer(2.0).timeout	
	insufficient_parent.visible = false 
	
func _handle_display_success() : 
	success_parent.visible = true
	await get_tree().create_timer(1.0).timeout	
	success_parent.visible = false 
	
	
	
