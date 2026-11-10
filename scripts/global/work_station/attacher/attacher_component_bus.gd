extends Node

signal toggle_show_view_attacher_label(toggle_value : bool)
signal opened_attacher()

var main_stat_replacement_state : Dictionary[String, StatJarItem] = {
	'strength' : null,
	'intelligence' : null,
	'community' : null,
}

var main_stat_replacement_failure_penality : Dictionary[String, bool] = {
	'strength' : false,
	'intelligence' :  false,
	'community' : false,
}
# called when dropping jar item into property (main stat)
# lets it know to refresh catalog
signal jar_item_from_catalog_used()

# used for drag and delete modal logic. kinda HACK
var showing_delete_modal : bool = false
