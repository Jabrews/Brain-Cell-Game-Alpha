extends Node

# refresh components
@onready var refresh_catalog : Node = $RefreshCatalog
@onready var refresh_main_stats : Node = $RefreshMainStats
@onready var refresh_blood_type_view : Node = $RefreshBloodTypeView
@onready var refresh_failure_chance_view : Node = $RefreshFailureChanceView
@onready var refresh_confirm_btn : Node = $RefreshConfirmBtn
@onready var refresh_focus : Node = $RefreshFocus
# other components
@onready var parent_station_attacher : Node3D = $"../.."
@onready var compute_failure_penality : Node = $"../ComputeFailurePenality"


func _ready() -> void:
	GLAttacherComponentBus.connect('jar_item_from_catalog_used', _refresh)

func _refresh() :
	
	# hacky but works
	if parent_station_attacher.failure_rate_enabled :
		compute_failure_penality._compute()
	
	refresh_main_stats._refresh()
	refresh_catalog._refresh()
	refresh_blood_type_view._refresh()
	refresh_failure_chance_view._refresh()
	refresh_confirm_btn._refresh()
	
	refresh_focus._refresh()
