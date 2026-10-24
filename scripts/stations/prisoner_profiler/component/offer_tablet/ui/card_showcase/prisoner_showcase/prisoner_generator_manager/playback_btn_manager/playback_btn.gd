extends Node

# Components
@onready var hover_rect: ColorRect = $HoverRect
@onready var btn_texture_rect: TextureRect = $BtnTextureRect
@onready var playback_btn_manager : Node =$"../../../PrisonerGeneratorManager/PlaybackBtnManager"


var hovered: bool = false

func _ready() -> void:
	btn_texture_rect.mouse_entered.connect(_handle_mouse_entered)
	btn_texture_rect.mouse_exited.connect(_handle_mouse_exited)
	btn_texture_rect.focus_entered.connect(_handle_mouse_entered)
	btn_texture_rect.focus_exited.connect(_handle_mouse_exited)
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack") and hovered:
		playback_btn_manager._handle_btn_pressed()
	if Input.is_action_just_pressed("interact") and hovered:
		playback_btn_manager._handle_btn_pressed()


func _handle_mouse_entered() -> void:
	hovered = true
	hover_rect.visible = true


func _handle_mouse_exited() -> void:
	hovered = false
	hover_rect.visible = false
