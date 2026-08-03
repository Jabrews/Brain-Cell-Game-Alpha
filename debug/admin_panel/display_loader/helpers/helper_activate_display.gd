extends Node

# display components
@onready var test_data_display : Control = $"../Displays/TestDataDisplay"
@onready var test_data_display_color_rect : ColorRect = $"../Displays/TestDataDisplay/ColorRect"

func _activate(display_type : String, admin_panel_root : AdminPanelRoot) :

	match display_type :
		'test_data' : 
			test_data_display.visible = true
			test_data_display_color_rect.color = Color.from_string(admin_panel_root.test_data.color, Color.WHITE)
		_ : 
			push_error('invalid display type')
		

func _deactivate_all_displays() :
	test_data_display.visible = false
