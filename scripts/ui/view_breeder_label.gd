extends Label

func _ready() -> void:
	GLBreedingComponetsBus.connect('toggle_show_view_breeder_label', _handle_toggle_show_view_breeder_label)

func _handle_toggle_show_view_breeder_label(toggle_value : bool) :
	visible = toggle_value
