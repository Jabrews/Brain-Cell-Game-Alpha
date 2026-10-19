extends Node

# Components
@onready var hover_rect: ColorRect = $HoverRect
@onready var btn_texture_rect: TextureRect = $BtnTextureRect
@onready var handle_media_controll_pressed: Node = $"../../../PrisGenStateMachine/HandleMediaControllPressed"

# textures
@onready var play_texture: Texture = preload("res://models/prisoner_profiler/prisoner_showcase/media_control_stop.png")
@onready var pause_texture: Texture = preload("res://models/prisoner_profiler/prisoner_showcase/media_control_start.png")

var hovered: bool = false
var active_playback_control: String = "play"

func _ready() -> void:
	btn_texture_rect.mouse_entered.connect(_handle_mouse_entered)
	btn_texture_rect.mouse_exited.connect(_handle_mouse_exited)
	
	update_btn_visual()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack") and hovered:
		_switch_active_control()


func _handle_mouse_entered() -> void:
	hovered = true
	hover_rect.visible = true


func _handle_mouse_exited() -> void:
	hovered = false
	hover_rect.visible = false


func _switch_active_control() -> void:
	if active_playback_control == "play":
		active_playback_control = "pause"
	else:
		active_playback_control = "play"

	update_btn_visual()
	handle_media_controll_pressed._handle(active_playback_control)


func update_btn_visual() -> void:
	match active_playback_control:
		"play":
			btn_texture_rect.texture = pause_texture
		"pause":
			btn_texture_rect.texture = play_texture
