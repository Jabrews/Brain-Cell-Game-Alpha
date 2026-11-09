extends Node

# componets
@onready var stat_type_label : Label = $StatTypeLabel
@onready var display_default_stats : Node = $DisplayDefaultStats
@onready var display_replacement : Node = $DisplayReplacement

# drag components HACK
# for detect rect when handling stat_jar_item on drop
@onready var default_detect_rect : ColorRect = $DefaultDetectRect # also used here, must get rid of if replacement active
@onready var parent_stat_item_drag_node : Node =$"../../../ParentStatItemDragNode"

@export var stat_type : String = 'strength'

var main_stat_enabled : bool = false

var replacement_stat_jar_item : StatJarItem 

func _ready() -> void:
	stat_type_label.text = str(stat_type)

func _display(loaded_cell : BrainCell) : 
	
	# attemp to location within state
	replacement_stat_jar_item = GLAttacherComponentBus.main_stat_replacement_state[stat_type]
	
	if replacement_stat_jar_item : 
		# will get complicated with focus
		default_detect_rect.visible = false
	else :
		default_detect_rect.visible = true
	
	
	var cell_stat : BrainCellStat = loaded_cell.get_stat(stat_type)	
	
	if not cell_stat : 
		push_error('main stat of type : ', stat_type, ' unable to find corrisponding cell stat')
		return
	
	# if hidden. stat isnt enabled 	
	if cell_stat.hidden : 
		main_stat_enabled = false
	else : 
		main_stat_enabled = true
	
	display_default_stats._display(cell_stat)
	display_replacement._display(replacement_stat_jar_item)

	
func _handle_stat_jar_item_dropped(stat_jar_item : StatJarItem) :
	
	# cannot load cases, invalid main stat (hidden) or already has replacement
	if not main_stat_enabled or replacement_stat_jar_item: 
		return
	else :
		replacement_stat_jar_item = stat_jar_item		
		
		GLAttacherComponentBus.main_stat_replacement_state[stat_type] = replacement_stat_jar_item		
		
		# notice will be auto refreshed and display replacement via signal
		GLAttacherComponentBus.emit_signal('jar_item_from_catalog_used')
	
	
	
	
	
