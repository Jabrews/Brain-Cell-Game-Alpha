extends Button

@onready var parent_shareholder_demand_provider: Node3D = $"../.."
@onready var s_hover : AudioStreamPlayer3D = $"../../Sounds/Hover"

func _ready() -> void:
	pressed.connect(_handle_btn_pressed)
	connect('mouse_entered', _handle_mouse_enter)


func _handle_btn_pressed() -> void:
	parent_shareholder_demand_provider._handle_exit_btn_pressed()

func _handle_mouse_enter() -> void : 
	s_hover.play()
