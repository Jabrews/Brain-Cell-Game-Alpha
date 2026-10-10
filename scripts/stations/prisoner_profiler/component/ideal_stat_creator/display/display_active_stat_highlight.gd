extends Node

@onready var active_stat_highlight_meshes: Array[MeshInstance3D] = [
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/ActiveStatHighlightMeshes/StrengthActive",
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/ActiveStatHighlightMeshes/IntelligenceActive",
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/ActiveStatHighlightMeshes/CommunityActive"
]



func _display_type(selected_stat_index : int) :
	
	for highlight_mesh : MeshInstance3D in active_stat_highlight_meshes	 :
		highlight_mesh.visible = false
	
	# detect if none
	if selected_stat_index > 2 : 
		return
	
	else : 
		active_stat_highlight_meshes[selected_stat_index].visible = true
	
	
