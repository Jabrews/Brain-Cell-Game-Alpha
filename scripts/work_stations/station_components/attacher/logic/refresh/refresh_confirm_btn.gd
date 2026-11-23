extends Node

# Components
@onready var hint_label: Label = $"../../../AttacherUI/InteractFooter/ConfirmBtn/Hint/HintText"
@onready var confirm_label : Label = $"../../../AttacherUI/InteractFooter/ConfirmBtn/ConfirmLabel"
@onready var btn_bg: ColorRect = $"../../../AttacherUI/InteractFooter/ConfirmBtn/BtnBg"


func _refresh() -> void:
	var main_stat_replacement_state: Dictionary[String, StatJarItem] = GLAttacherComponentBus.main_stat_replacement_state

	var found_valid_change: bool = false

	for key: String in main_stat_replacement_state:
		var replacement_jar_item: StatJarItem = main_stat_replacement_state[key]

		if replacement_jar_item:
			found_valid_change = true
			break

	if found_valid_change:
		hint_label.text = "confirm new cell"
		confirm_label.modulate.a = 1.0
		btn_bg.modulate.a = 1.0
	else:
		hint_label.text = "must change cell"
		confirm_label.modulate.a = 0.3
		btn_bg.modulate.a = 0.3
