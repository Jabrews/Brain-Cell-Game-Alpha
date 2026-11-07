extends Node

var corrisponding_stat_jar_item : StatJarItem

func _start(stat_jar_item : StatJarItem) : 
	corrisponding_stat_jar_item = stat_jar_item

# called when item is currently acting as replacement stat
func _item_used() :
	pass
