extends Node

# components
@onready var parent_admin_panel : Control = $".."
@onready var back_btn : ColorRect = $BackBtn

# helper components
@onready var helper_activate_display : Node = $HelperActivateDisplay




var back_btn_hovered : bool = false
var display_active : bool = false

func _ready() -> void:
	back_btn.connect('mouse_entered', func(): back_btn_hovered = true)
	back_btn.connect('mouse_exited', func(): back_btn_hovered = false)

func _process(_delta: float) -> void:
	if not display_active : 
		return
	
	if Input.is_action_just_pressed('attack') :
		if back_btn_hovered : 
			_handle_back_btn_pressed()

func _handle_display_btn_pressed(display_type : String) :
	
	# prevent overlap
	if display_active : 
		return
	
	helper_activate_display._activate(display_type, parent_admin_panel.admin_panel_root)
		
	back_btn.visible = true
	
	display_active = true
	

func _handle_back_btn_pressed() :
	back_btn.visible = false
	display_active = false
	helper_activate_display._deactivate_all_displays()
		
	
	
	
