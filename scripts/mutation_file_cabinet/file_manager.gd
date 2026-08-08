extends Node

# NOTE this all must match mutation manager mutations. specifically the type
var file_infos: Array[FileInfo] = [
	FileInfo.new("airborne", false, "Cell possesses the ability of flight.\n\nInstead of flying recreationally, it uses this ability to commit suicide.\n\nFoundation recommends keeping the cell away from ceiling fans and other machinery capable."),
	FileInfo.new("sentient", false, "Cell possesses a strong human like\npresence.\n\nPerhaps memories of the past still keep it\ncompany.\n\nBrain has never presented any hazardous anomalies to the Foundation's knowledge. "),
	FileInfo.new("lonley", false, "Cell is extremely codependent and must always have another cell within a 3 foot radius.\n\nIf left alone, cell will slowly cry itself to death.\n\nFoundation supplies a face hologram above the cell to help with understanding"),
	FileInfo.new("disrupter", false, "Cell has access to strange energy waves, allowing it to alter nearby hologram screens.\n\nFoundation has recorded this behavior becoming less prevalent when the cell is hidden from technological devices. "),
	FileInfo.new("exsplosive", false, "Cell contains trace amounts of unstable compounds, causing the cell to explode after a certain amount of time.\n\nExplosion will kill other cells and scientists nearby.\nFoundation recommends disposing of the cell before instability reaches critical levels. "),
	FileInfo.new("cognisance", false, "Cell is extremely hostile and will attempt to attack nearby scientists.\n\nIt has never been recorded moving while directly observed and seems to prefer striking when the user's back is turned. "),
	FileInfo.new("telekinetic", false, "Cell possesses strong psychic energy.\n\nFoundation has recorded manifestations of the cell producing crystal objects to attack nearby scientists."),
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
