extends Node

# NOTE this all must match mutation manager mutations. specifically the type
var file_infos: Array[FileInfo] = [
	FileInfo.new("airborne", false, ""),
	FileInfo.new("teleportation", false, ""),
	FileInfo.new("sentient", false, ""),
	FileInfo.new("lonley", false, ""),
	FileInfo.new("disrupter", false, ""),
	FileInfo.new("exsplosive", false, ""),
	FileInfo.new("infectious", false, ""),
	FileInfo.new("cognisance", false, ""),
	FileInfo.new("telekinetic", false, ""),
	FileInfo.new("unstable", false, ""),
]

# components
@onready var files_parent_node: Node3D = $"../Files"


func _refresh_file_info_seen_by_player() -> void:
	var mutations_seen_manager: Node = get_parent().mutations_seen_manager

	# Update seen status for every FileInfo.
	for file_info: FileInfo in file_infos:
		var mutation_was_seen: bool = mutations_seen_manager.mutations_seen.get(file_info.type, false)
		file_info.seen = mutation_was_seen

	var file_parents: Array[Node] = files_parent_node.get_children()

	for i: int in range(file_parents.size()):
		var file_parent: Node = file_parents[i]

		var file_info_to_load: FileInfo = null

		if i < file_infos.size():
			file_info_to_load = file_infos[i]

		file_parent._load_file_info(file_info_to_load)
