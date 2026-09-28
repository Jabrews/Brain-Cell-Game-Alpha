extends TextureRect

# components
@onready var percant_label : Label = $PercantLabel
@onready var emergency_sprite : Sprite2D = $Emergency
@onready var checkmark_sprite : Sprite2D = $CheckMark

var flash_emergency_tween : Tween
var flash_checkmark_tween : Tween

var current_display_state : String = ""


func _display(dissolved_stat : DissolveStat) -> void:
	
	var threshold_stat : ThresholdStat = dissolved_stat.corresponding_threshold_stat
	
	_update_percant_label(
		threshold_stat.max_value,
		threshold_stat.current_value
	)
	
	
	# disabled
	if threshold_stat.disabled:
		_set_display_state("disabled")
		return
	
	
	# finished
	if threshold_stat.finished:
		_set_display_state("finished")
		return
	
	
	# low turns warning
	var active_piece : ThresholdPiece = (
		GLGoalThresholdManagerBus.active_goal_threshold.get_active_piece()
	)
	
	if active_piece.turns_remaining <= 1:
		_set_display_state("emergency")
		return
	
	
	# less than 25% remaining
	var percent_of_max : float = threshold_stat.max_value * 0.25
	var current_value : float = threshold_stat.current_value
	
	if current_value <= percent_of_max:
		_set_display_state("checkmark")
		return
	
	
	# normal display
	_set_display_state("normal")


func _set_display_state(new_state : String) -> void:
	
	# already displaying this state
	# do not restart tweens
	if current_display_state == new_state:
		return
	
	current_display_state = new_state
	
	
	# stop previous tweens
	if flash_emergency_tween:
		flash_emergency_tween.kill()
		flash_emergency_tween = null
	
	if flash_checkmark_tween:
		flash_checkmark_tween.kill()
		flash_checkmark_tween = null
	
	
	# reset visuals
	percant_label.visible = false
	emergency_sprite.visible = false
	checkmark_sprite.visible = false
	
	percant_label.modulate.a = 1.0
	emergency_sprite.modulate.a = 1.0
	checkmark_sprite.modulate.a = 1.0
	
	
	match new_state:
		
		"disabled":
			pass
		
		
		"finished":
			checkmark_sprite.visible = true
		
		
		"emergency":
			toggle_flash_emergency_tween(true)
		
		
		"checkmark":
			toggle_flash_checkmark_tween(true)
		
		
		"normal":
			percant_label.visible = true


func toggle_flash_emergency_tween(toggle_value : bool) -> void:
	
	if flash_emergency_tween:
		flash_emergency_tween.kill()
		flash_emergency_tween = null
	
	
	if not toggle_value:
		emergency_sprite.visible = false
		emergency_sprite.modulate.a = 1.0
		percant_label.modulate.a = 1.0
		return
	
	
	emergency_sprite.visible = true
	percant_label.visible = true
	
	emergency_sprite.modulate.a = 1.0
	percant_label.modulate.a = 0.0
	
	
	flash_emergency_tween = create_tween()
	flash_emergency_tween.set_loops()
	
	flash_emergency_tween.tween_property(
		emergency_sprite,
		"modulate:a",
		0.0,
		1.0
	)
	
	flash_emergency_tween.parallel().tween_property(
		percant_label,
		"modulate:a",
		1.0,
		1.0
	)
	
	flash_emergency_tween.tween_property(
		emergency_sprite,
		"modulate:a",
		1.0,
		1.0
	)
	
	flash_emergency_tween.parallel().tween_property(
		percant_label,
		"modulate:a",
		0.0,
		1.0
	)


func toggle_flash_checkmark_tween(toggle_value : bool) -> void:
	
	if flash_checkmark_tween:
		flash_checkmark_tween.kill()
		flash_checkmark_tween = null
	
	
	if not toggle_value:
		checkmark_sprite.visible = false
		checkmark_sprite.modulate.a = 1.0
		percant_label.modulate.a = 1.0
		return
	
	
	checkmark_sprite.visible = true
	percant_label.visible = true
	
	checkmark_sprite.modulate.a = 1.0
	percant_label.modulate.a = 0.0
	
	
	flash_checkmark_tween = create_tween()
	flash_checkmark_tween.set_loops()
	
	flash_checkmark_tween.tween_property(
		checkmark_sprite,
		"modulate:a",
		0.0,
		1.0
	)
	
	flash_checkmark_tween.parallel().tween_property(
		percant_label,
		"modulate:a",
		1.0,
		1.0
	)
	
	flash_checkmark_tween.tween_property(
		checkmark_sprite,
		"modulate:a",
		1.0,
		1.0
	)
	
	flash_checkmark_tween.parallel().tween_property(
		percant_label,
		"modulate:a",
		0.0,
		1.0
	)


func _update_percant_label(max_value : float, curr_value : float) -> void:
	
	if max_value <= 0.0:
		percant_label.text = "0%"
		
		self.material.set_shader_parameter(
			"progress",
			0.0
		)
		
		return
	
	
	var percent : float = (
		1.0 - (curr_value / max_value)
	) * 100.0
	
	percent = clampf(percent, 0.0, 100.0)
	
	percant_label.text = str(roundi(percent)) + "%"
	
	
	self.material.set_shader_parameter(
		"progress",
		curr_value / max_value
	)
