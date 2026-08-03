extends Control

# components 
@onready var exit_btn : ColorRect = $MainNavBar/ExitBtnContainer/ExitBtn
@onready var display_loader : Control = $DisplayLoader
# helper components
@onready var helper_parse_preload : Node = $HelperParsePreload
@onready var helper_create_inital : Node = $HelperCreateInital
@onready var helper_save_admin_panel_root : Node = $HelperSaveAdminPanelRoot

var panel_open : bool = false
var exit_btn_hovered_over : bool = false

# preload json
@export var preload_admin_panel_root_json_path: String 

var admin_panel_root : AdminPanelRoot

	
func _ready() -> void:
	# exit btn
	exit_btn.mouse_entered.connect(func(): exit_btn_hovered_over = true)
	exit_btn.mouse_exited.connect(func(): exit_btn_hovered_over = false)
	
	# create inital admin panel loop
	_handle_inital_admin_panel_root()


	
func _process(_delta: float) -> void: 
	
	if not GameAdminPanel.enabled : 
		return
	
	# entrance event	
	if Input.is_action_just_pressed('admin_panel') :
		if not panel_open :
			toggle_display_admin_panel(true)
	# exit event 
	if Input.is_action_just_pressed('attack') :
		if panel_open and exit_btn_hovered_over :
			toggle_display_admin_panel(false)
			

func toggle_display_admin_panel(toggle_value : bool) :
	if toggle_value :
		panel_open = true
		visible = true
		# toggle paused 
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		
	else : 
		panel_open = false
		visible = false
		# toggle unpaused
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false 

func _handle_inital_admin_panel_root() :
	# preload
	if preload_admin_panel_root_json_path :
		admin_panel_root = helper_parse_preload._parse_preload(
			preload_admin_panel_root_json_path
		)
	# regular create
	else : 
		admin_panel_root = helper_create_inital._create_inital()


# runs on end of game. save info
func _notification(what: int) -> void:
	
	# only update non pre-loaded roots
	if not preload_admin_panel_root_json_path : 	
		if what == NOTIFICATION_WM_CLOSE_REQUEST:
			helper_save_admin_panel_root._save(admin_panel_root)
		
	# Then safely quit the tree
	#get_tree().quit()
