extends Node

# components
@onready var refresh_catalog : Node = $RefreshCatalog
@onready var refresh_main_stats : Node = $RefreshMainStats
@onready var refresh_blood_type_view : Node = $RefreshBloodTypeView
@onready var refresh_failure_chance_view : Node = $RefreshFailureChanceView

func _ready() -> void:
	GLAttacherComponentBus.connect('jar_item_from_catalog_used', _refresh)

func _refresh() :
	refresh_catalog._refresh()
	refresh_main_stats._refresh()
	refresh_blood_type_view._refresh()
	refresh_failure_chance_view._refresh()
