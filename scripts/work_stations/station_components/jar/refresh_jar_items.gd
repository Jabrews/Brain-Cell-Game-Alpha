extends Node

@onready var jar_item_meshes: Array[MeshInstance3D] = [
	$"../JarItems/MeshInstance3D",
	$"../JarItems/MeshInstance3D2",
	$"../JarItems/MeshInstance3D3",
	$"../JarItems/MeshInstance3D4"
]

var displayed_jar_items_len: int = 0
var is_removing: bool = false


func _ready() -> void:
	displayed_jar_items_len = mini(
		GLJarComponentBus.jar_items.size(),
		jar_item_meshes.size()
	)
	
	await get_tree().process_frame

	for index in range(jar_item_meshes.size()):
		var mesh := jar_item_meshes[index]
		mesh.visible = index < displayed_jar_items_len
		mesh._stop()


func _refresh() -> void:
	if is_removing:
		return

	var curr_jar_items_len: int = mini(
		GLJarComponentBus.jar_items.size(),
		jar_item_meshes.size()
	)

	# Removed items
	if curr_jar_items_len < displayed_jar_items_len:
		_process_removal_queue()
		return

	# Added items
	for index in range(jar_item_meshes.size()):
		var mesh := jar_item_meshes[index]
		var was_visible := index < displayed_jar_items_len

		mesh.visible = index < curr_jar_items_len

		if not was_visible and mesh.visible:
			mesh._activate()
		else:
			mesh._stop()

	displayed_jar_items_len = curr_jar_items_len


func _process_removal_queue() -> void:
	is_removing = true

	# Keep removing until the displayed count matches the actual count.
	while displayed_jar_items_len > GLJarComponentBus.jar_items.size():

		var index: int = displayed_jar_items_len - 1
		var mesh: MeshInstance3D = jar_item_meshes[index]

		mesh._stop()

		# Wait until this item's removal animation finishes.
		await mesh._animate_removal()

		mesh.visible = false
		displayed_jar_items_len -= 1

	is_removing = false

	# Refresh again in case the item count changed during animations.
	_refresh()
