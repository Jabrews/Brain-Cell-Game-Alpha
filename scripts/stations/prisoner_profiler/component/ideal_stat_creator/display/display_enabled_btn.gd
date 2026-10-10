extends Node

@onready var on_off_label: Label3D = $"../../../IdealStatCreator/ControlInterface/Btns/EnabledBtn/OnOffLabel"
@onready var on_off_btn_mesh: MeshInstance3D = $"../../../IdealStatCreator/ControlInterface/Btns/EnabledBtn/MeshInstance3D"

const BTN_ON_COLOR: Color = Color.GREEN
const BTN_OFF_COLOR: Color = Color.RED

const BTN_ON_TEXT: String = "on"
const BTN_OFF_TEXT: String = "off"


func _ready() -> void:
	on_off_btn_mesh.material_override = StandardMaterial3D.new()
	_display_btn(null)


func _display_btn(active_ideal_stat: IdealStat) -> void:
	if active_ideal_stat == null or not active_ideal_stat.enabled:
		_set_display(BTN_OFF_TEXT, BTN_OFF_COLOR)
	else:
		_set_display(BTN_ON_TEXT, BTN_ON_COLOR)


func _set_display(label_text: String, display_color: Color) -> void:
	on_off_label.text = label_text
	on_off_btn_mesh.material_override.albedo_color = display_color
