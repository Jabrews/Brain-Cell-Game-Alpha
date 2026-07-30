extends Node

# 2d bubble components
@onready var speech_bubble_label : Label = $SpeechBubbleTV/SubViewport/ScreenTextSpeechBubble/VBoxContainer/PanelContainer/Label
@onready var bubble_panel_container : PanelContainer = $SpeechBubbleTV/SubViewport/ScreenTextSpeechBubble/VBoxContainer/PanelContainer
# 3d bibble componnets
@onready var sub_viewport : SubViewport = $SpeechBubbleTV/SubViewport
@onready var mesh_instance : MeshInstance3D = $SpeechBubbleTV


func _load_text(text : String) :

		speech_bubble_label.text = text

		await get_tree().process_frame

		var panel_size: Vector2 = bubble_panel_container.size

		sub_viewport.size = Vector2i(
			ceili(panel_size.x),
			ceili(panel_size.y) + 20
		)

		var quad_mesh := mesh_instance.mesh as QuadMesh

		if quad_mesh:
			var pixels_to_world_scale: float = 0.005
			quad_mesh.size = panel_size * pixels_to_world_scale
		
