extends Node

signal toggle_show_view_attacher_label(toggle_value : bool)
signal opened_attacher()

var main_stat_replacement_state : Dictionary[String, StatJarItem] = {
	'strength' : null,
	'intelligence' : null,
	'community' : null,
}
