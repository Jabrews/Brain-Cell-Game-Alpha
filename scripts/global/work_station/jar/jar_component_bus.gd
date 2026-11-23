extends Node

var jar_items : Array[JarItem] = [
	# NOTICE. delete placeholder
	StatJarItem.new(BrainCellStat.new('strength', true, 100, 0, false))
]

signal add_jar_item(jar_item : JarItem)
signal remove_jar_item(jar_item : JarItem)

signal play_sound(sound_type : String)
