extends Control

@onready var lock_rect : TextureRect = $LockRect
@onready var hint : Control = $Hint
@onready var parent_box : Control = $"../.."

var lock_tween : Tween

var hovered : bool = false


func _ready() -> void:
	lock_rect.connect('mouse_entered', _handle_mouse_entered)
	lock_rect.connect('mouse_exited', _handle_mouse_exited)

func _process(_delta: float) -> void:
	if hovered :
		if Input.is_action_just_pressed('attack') :
			_handle_lock_clicked()


func _toggle_lock(toggle_value : bool) :
	
	visible = toggle_value
	_toggle_rect_shake(toggle_value)


func _handle_mouse_entered() :
	hovered = true
	hint.visible = true
	_toggle_rect_shake(false)

func _handle_mouse_exited() :
	hovered = false
	hint.visible = false
	_toggle_rect_shake(true)
	
	
func _toggle_rect_shake(toggle_value : bool) :
	
	if lock_tween: 
		lock_tween.kill()
	
	if toggle_value : 
		lock_tween = create_tween()
		lock_tween.set_loops()		
		lock_tween.tween_property(lock_rect, 'rotation', 0.1, 0.1)		
		lock_tween.tween_property(lock_rect, 'rotation', 0.0, 0.1)		
		lock_tween.tween_property(lock_rect, 'rotation', -0.1, 0.1)		

func _handle_lock_clicked() :
	parent_box._handle_box_empty(true, true)
		
		
		
