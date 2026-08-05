extends Control

# helper components
@onready var helper_create_inital : Node = $HelperCreateInital
@onready var helper_save_admin_panel_root : Node = $HelperSaveAdminPanelRoot

func _ready() -> void:
	
	if not GameAdminPanel.enabled 	: 
		return
	
	# create inital admin panel loop
	_handle_inital_admin_panel_root()

func _handle_inital_admin_panel_root() :
	GameAdminPanel.admin_panel_root = helper_create_inital._create_inital()


# runs on end of game. save info
func _notification(what: int) -> void:
	
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		helper_save_admin_panel_root._save(GameAdminPanel.admin_panel_root)
		
