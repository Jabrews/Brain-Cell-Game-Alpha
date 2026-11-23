extends Control 

@export var stat_type : String

var stat_hovered_over : bool = false
var stat_disabled : bool = false
var loaded_stat : BrainCellStat 

# components
@onready var highlight : TextureRect = $Highlight
@onready var bar : TextureRect = $StatVBox/Bar
@onready var defect_bar : TextureProgressBar = $StatVBox/DefectBar
@onready var hidden_rect : TextureRect = $StatVBox/HiddenRect
@onready var off_parent : Control = $StatVBox/Off
@onready var parent_usable_item_popup : Control =$"../../../../.."

func _ready() -> void:
	mouse_entered.connect(_handle_mouse_entered)
	mouse_exited.connect(_handle_mouse_exited)
	focus_entered.connect(_handle_mouse_entered)
	focus_exited.connect(_handle_mouse_exited)
	
	bar.material = bar.material.duplicate()	


func _process(_delta: float) -> void:
	if stat_disabled:
		return
	
	if stat_hovered_over:
		if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed('interact'):
			
			if parent_usable_item_popup.popup_type == 'hidden_shot' :	
				if not loaded_stat.hidden :
					return
			
			parent_usable_item_popup._handle_pop_up_stat_selected(stat_type)


func _handle_mouse_entered() -> void:
	if stat_disabled:	
		return
	
	highlight.visible = true
	stat_hovered_over = true


func _handle_mouse_exited() -> void:
	highlight.visible = false
	stat_hovered_over = false 


func handle_display_stat_info(stat : BrainCellStat) -> void:
	if stat == null:
		loaded_stat = null
		return
	
	visible = true
	
	reset_stat()
	
	loaded_stat = stat
	
	var max_val : float = IVCellCreator.max_stat_value
	
	# disabled stat
	if stat.enabled == false:
		stat_disabled = true
		off_parent.visible = true
		return
	
	stat_disabled = false
	
	if stat.hidden : 
		hidden_rect.visible = true
		return
	
	# make bars visual
	bar.visible = true
	defect_bar.visible = true
	
	# defect bar
	defect_bar.max_value = max_val
	defect_bar.value = stat.defect
	
	# prisoner stat value
	var prisoner_value : float = stat.value / max_val
	bar.material.set_shader_parameter("prisoner_value", prisoner_value)


func reset_stat() -> void:
	bar.visible = false
	defect_bar.visible = false
	hidden_rect.visible = false
	stat_disabled = false
	off_parent.visible = false
	stat_hovered_over = false
	highlight.visible = false
	
	defect_bar.value = 0
	bar.material.set_shader_parameter("prisoner_value", 0.0)
	

	
