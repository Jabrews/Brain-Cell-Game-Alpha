extends Node

# components
@onready var parent_attacher: Node3D =$"../.."
@onready var catalog_parent  : VBoxContainer = $"../../AttacherUI/Content/JarItemCatalog/CenterContainer/ScrollContainer/CatalogParent"
@onready var exit_btn_bg : ColorRect = $"../../AttacherUI/Content/ExitHeader/HBoxContainer/ExitBtn/BG"

# NOTE : used in refresh and modal


func _ready() -> void:
	GLAttacherComponentBus.connect('reset_ui_focus', _set_inital)

func _set_inital() : 
	
	if GAMEInputTypeDetector.input_type != 'controller' : 
		return
	
	
	
	
	await get_tree().process_frame 
	
	var jar_items : Array[Node] = catalog_parent.get_children()
	
	# detect if jar items
	if len(jar_items) > 0 :
		
		var first_jar_item : Control = jar_items[0]
		
		first_jar_item.bg.grab_focus()
		
		return
	
		
	exit_btn_bg.grab_focus()
	
	
	
	
	
		
	
	
