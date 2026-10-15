extends Area3D

# handle component
@onready var toggle_display_offer_ui : Node = $"../../../../Logic/OfferTablet/ToggleDisplayOfferUi"


func _toggle_hologram_hint(toggle_value: bool) -> void:
	GLPrisonerProfilerComponentsBus.emit_signal('toggle_show_tablet_label', toggle_value)

func _handle_hologram_interacted() -> void:
	GLPrisonerProfilerComponentsBus.emit_signal('toggle_show_tablet_label', false)
	toggle_display_offer_ui._toggle(true)
