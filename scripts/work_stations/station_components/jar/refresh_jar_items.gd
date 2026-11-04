extends Node

@onready var jar_item_meshes: Array[MeshInstance3D] = [
	$"../JarItems/MeshInstance3D",
	$"../JarItems/MeshInstance3D2",
	$"../JarItems/MeshInstance3D3",
	$"../JarItems/MeshInstance3D4"
]

var last_jar_items_len: int = 0


func _ready() -> void:
	last_jar_items_len = GLJarComponentBus.jar_items.size()


func _refresh() -> void:
	var curr_jar_items_len: int = GLJarComponentBus.jar_items.size()

	for index in range(jar_item_meshes.size()):
		jar_item_meshes[index].visible = index < curr_jar_items_len
		jar_item_meshes[index]._stop()
		

	# Activate the display mesh for the newly added item.
	if curr_jar_items_len > last_jar_items_len:
		var new_item_index: int = curr_jar_items_len - 1

		if new_item_index < jar_item_meshes.size():
			var new_item: MeshInstance3D = jar_item_meshes[new_item_index]
			if new_item.has_method("_activate"):
				new_item.call("_activate")

	last_jar_items_len = curr_jar_items_len
