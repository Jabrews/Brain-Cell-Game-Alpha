extends Control

# components
@onready var btn_bg : TextureRect = $BtnBG
@onready var hover_border : TextureRect = $HoverBorder
@onready var remove_hint : Control = $RemoveHint
@onready var parent_main_stat : Control = $"../.."

var hovered : bool = false

func _ready() -> void:
	btn_bg.connect('mouse_entered', _handle_mouse_entered)
	btn_bg.connect('mouse_exited', _handle_mouse_exited)
	btn_bg.connect('focus_entered', _handle_mouse_entered)
	btn_bg.connect('focus_exited', _handle_mouse_exited)

func _process(_delta: float) -> void:
	if hovered : 
		if Input.is_action_just_pressed('interact') or Input.is_action_just_pressed('attack') :
			handle_button_pressed()

func handle_button_pressed()  :
	
	var stat_type : String = parent_main_stat.stat_type	
	
	if parent_main_stat.replacement_stat_jar_item :
		GLAttacherComponentBus.main_stat_replacement_state[stat_type] = null 
		
		# force refresh
		GLAttacherComponentBus.emit_signal('jar_item_from_catalog_used')
		
		GLAttacherComponentBus.emit_signal('play_sound', 'item_removed')
		
		GLAttacherComponentBus.emit_signal('reset_ui_focus')
		
		
	else : 
		push_error('attempted to remove replacement stat, no jar item connected. on : ', stat_type)
		return


func _handle_mouse_entered() :
	hover_border.visible = true
	remove_hint.visible = true
	
	hovered = true
	
func _handle_mouse_exited() :
	hover_border.visible = false 
	remove_hint.visible = false 
	
	hovered = false 
