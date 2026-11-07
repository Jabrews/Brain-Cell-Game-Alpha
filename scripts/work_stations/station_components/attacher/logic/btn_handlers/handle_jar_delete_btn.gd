extends Node

@onready var delete_modal : Control = $"../../../AttacherUI/DeleteModal"
@onready var refresh_catalog : Node = $"../../RefreshCatalog"
@onready var handle_display_ui : Node = $"../../HandleDisplayUi"

var showing_delete_modal : bool = false
var saved_jar_item : JarItem 

func _handle(jar_item : JarItem) :
	
	
	delete_modal.visible = true
	showing_delete_modal = true
	
	saved_jar_item = jar_item

func _handle_modal_btn_pressed(btn_type : String) :
	
	if btn_type == 'confirm' :	
		GLJarComponentBus.emit_signal('remove_jar_item', saved_jar_item)
		refresh_catalog._refresh()
	
	delete_modal.visible = false 
	showing_delete_modal = false 
	saved_jar_item = null
	
	if btn_type == 'confirm' : 	
		await get_tree().process_frame
		handle_display_ui._toggle_display(false)
	
	
	
	



	
	
	
	
