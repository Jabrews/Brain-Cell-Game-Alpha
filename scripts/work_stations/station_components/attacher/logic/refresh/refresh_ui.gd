extends Node

# components
@onready var refresh_catalog : Node = $RefreshCatalog
@onready var refresh_main_stats : Node = $RefreshMainStats

func _refresh() :
	refresh_catalog._refresh()
	refresh_main_stats._refresh()
