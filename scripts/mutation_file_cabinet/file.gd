extends Node3D 

var designated_file_info: FileInfo = null
var locked: bool = true

# parent componnet
@onready var mutation_file_cabinet : Node3D = $"../.."

# audio manager componnet
@onready var audio_manager : Node3D = $"../../AudioManager"

# get mutation symbol/icon
@onready var get_mutation_symbol : Node = $"../../GetMutationSymbol"


# file components
@onready var file_label: Label3D = $Label3D
@onready var detect_mouse_area: Area3D = $Area3D
@onready var mutation_icon_sprite: Sprite3D = $MutationIconSprite
@onready var locked_icon_sprite: Sprite3D = $LockedIconSprite

# click to view label
@onready var click_to_view_label : Label = $"../../ClickToView"


# hover stuff
var show_hover_delay_true: bool = false
var original_position: Vector3
var hover_y_addition: float = 0.06
var hover_tween: Tween
var file_being_hover_over : bool 


# lock stuff
var original_lock_pos: Vector3
var lock_shake_tween: Tween
var lock_is_shaking: bool = false
@export var lock_shake_amount: float = 0.015
@export var lock_shake_speed: float = 0.03


func _ready() -> void:
	
	load_file_label_style('disabled')
	
	original_position = position
	original_lock_pos = locked_icon_sprite.global_position
	
	detect_mouse_area.mouse_entered.connect(_handle_mouse_entered)
	detect_mouse_area.mouse_exited.connect(_handle_mouse_exited)

func _process(delta: float) -> void:
	if file_being_hover_over and designated_file_info and not locked: 
		if Input.is_action_just_pressed('attack') :
			mutation_file_cabinet._display_file_view(designated_file_info)



func _load_file_info(new_designated_file_info: FileInfo = null) -> void:
	designated_file_info = new_designated_file_info
	locked = true

	if designated_file_info == null:
		load_file_label_style("disabled")
		return

	if designated_file_info.seen:
		locked = false
		load_file_label_style("unlocked")
	else:
		load_file_label_style("locked")


func load_file_label_style(style: String) -> void:
	match style:
		"unlocked":
			var file_type: String = designated_file_info.type

			if file_type.length() > 10:
				file_label.scale = Vector3(0.55, 0.55, 0.55)
				file_label.text = file_type.substr(0, 6) + "."
			else:
				file_label.scale = Vector3(0.6, 0.6, 0.6)

				if file_type.length() > 8:
					file_label.text = file_type.substr(0, 8) + "."
				else:
					file_label.text = file_type
			
			
			locked_icon_sprite.visible = false 
			mutation_icon_sprite.visible = true
			mutation_icon_sprite.texture = get_mutation_symbol.get_symbol(designated_file_info.type)
		"locked":
			file_label.text = "locked"
			file_label.scale = Vector3(0.6, 0.6, 0.6)
			locked_icon_sprite.visible = true
			mutation_icon_sprite.visible = false

		"disabled":
			file_label.text = ""
			locked_icon_sprite.visible = false
			mutation_icon_sprite.visible = false


#### HOVER STUFF ######

func _handle_mouse_entered() -> void:
	
	if mutation_file_cabinet.file_being_viewed == true : 
		return
	
	file_being_hover_over = true	
	
	if designated_file_info == null:
		return
		
	if locked : 
		audio_manager.play_invalid()
		shake_lock()
		return

	show_hover_delay_true = true

	await get_tree().create_timer(0.15).timeout

	if show_hover_delay_true:
		audio_manager.play_valid()
		click_to_view_label.visible = true
		hover_file("up")


func _handle_mouse_exited() -> void:
	
	file_being_hover_over = false
	
	show_hover_delay_true = false
	click_to_view_label.visible = false 
	hover_file("down")


func hover_file(direction: String) -> void:
	var target_y: float = original_position.y
	
	match direction:
		"up":
			target_y = original_position.y + hover_y_addition
		"down":
			target_y = original_position.y
		_:
			push_error("Invalid hover direction: " + direction)
			return
	
	if hover_tween:
		hover_tween.kill()

	hover_tween = create_tween()
	hover_tween.tween_property(
		self,
		"position:y",
		target_y,
		0.25
	)

#####################

func shake_lock() -> void:
	if lock_is_shaking:
		return
	
	if not locked_icon_sprite.visible:
		return

	lock_is_shaking = true

	if lock_shake_tween:
		lock_shake_tween.kill()

	locked_icon_sprite.global_position = original_lock_pos

	lock_shake_tween = create_tween()

	lock_shake_tween.tween_property(
		locked_icon_sprite,
		"global_position:z",
		original_lock_pos.z + lock_shake_amount,
		lock_shake_speed
	)

	lock_shake_tween.tween_property(
		locked_icon_sprite,
		"global_position:z",
		original_lock_pos.z - lock_shake_amount,
		lock_shake_speed
	)

	lock_shake_tween.tween_property(
		locked_icon_sprite,
		"global_position:z",
		original_lock_pos.z + lock_shake_amount * 0.5,
		lock_shake_speed
	)

	lock_shake_tween.tween_property(
		locked_icon_sprite,
		"global_position:z",
		original_lock_pos.z,
		lock_shake_speed
	)

	await lock_shake_tween.finished

	locked_icon_sprite.global_position = original_lock_pos
	lock_is_shaking = false
	
