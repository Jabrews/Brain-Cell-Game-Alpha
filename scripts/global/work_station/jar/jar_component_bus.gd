extends Node

var jar_items : Array[JarItem] = []

signal add_jar_item(jar_item : JarItem)
signal remove_jar_item(jar_item : JarItem)

signal play_sound(sound_type : String)
