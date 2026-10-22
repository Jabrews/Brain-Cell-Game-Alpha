extends Sprite2D

var offer_picked_tween: Tween

func _ready() -> void:
	GLCinnamaticBus.connect('toggle_energy_cinnamatic', _handle_toggle_cinnamatic)
	GLCinnamaticBus.connect('toggle_extractor_cinnamatic', _handle_toggle_cinnamatic)
	GLCinnamaticBus.connect('toggle_goal_cinnamtic', _handle_toggle_goal_cinnamtic)
	GLCinnamaticBus.connect('toggle_offer_picked_cinnamatic', _handle_toggle_offer_picked_cinnamatic)


func _handle_toggle_cinnamatic(toggle_value : bool) : 
	
	modulate.a = 0.0
	
	if not toggle_value : 
		visible = false
	else : 
		visible = true
		var opacity_tween : Tween = create_tween()
		opacity_tween.tween_property(self, 'modulate:a', 1.0, 1.0)
	

func _handle_toggle_goal_cinnamtic(toggle_value : bool) :

	modulate.a = 0.0
	
	if not toggle_value : 
		visible = false
	else : 
		visible = true
		var opacity_tween : Tween = create_tween()
		opacity_tween.tween_property(self, 'modulate:a', 1.0, 2.0)
	

func _handle_toggle_offer_picked_cinnamatic(toggle_value: bool) -> void:
	if offer_picked_tween and offer_picked_tween.is_running():
		offer_picked_tween.kill()

	if toggle_value:
		visible = true

	offer_picked_tween = create_tween()
	offer_picked_tween.tween_property(
		self,
		"modulate:a",
		1.0 if toggle_value else 0.0,
		1.0
	)

	if not toggle_value:
		offer_picked_tween.tween_callback(_hide_offer_picked_cinnamatic)


func _hide_offer_picked_cinnamatic() -> void:
	visible = false
