extends Node

@onready var request_screen : Control = $"../RequestScreens"
@onready var energy_till_cancel : Control = $"../EnergyTillCancel"
@onready var energy_reward : Control = $"../Reward"
@onready var confirm_btn : ColorRect = $"../ConfirmBtn"

var request_screen_finale_pos : Vector2 = Vector2(0.0, 0.0)
var energy_till_cancel_finale_pos : Vector2 = Vector2(68.0 , -11.0)
var energy_reward_finale_pos : Vector2 = Vector2(433.0, -10.0)

var request_screen_org_pos : Vector2 
var energy_till_cancel_org_pos : Vector2 
var energy_reward_org_pos : Vector2 


func _ready() -> void:
	request_screen_org_pos = request_screen.global_position
	energy_till_cancel_org_pos = energy_till_cancel.global_position
	energy_reward_org_pos = energy_reward.global_position


func load_display() -> void:
	
	confirm_btn.modulate.a = 0.0
	
	# Request screen: smooth ease in/out
	var request_screen_tween := create_tween()
	request_screen_tween.tween_property(
		request_screen,
		"position",
		request_screen_finale_pos,
		1.0
	).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	
	await request_screen_tween.finished
	await get_tree().create_timer(0.5).timeout
	
	
	# Energy panels: bounce out
	var energy_panels_tween := create_tween()
	energy_panels_tween.set_parallel(true)
	
	energy_panels_tween.tween_property(
		energy_till_cancel,
		"position",
		energy_till_cancel_finale_pos,
		0.5
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	energy_panels_tween.tween_property(
		energy_reward,
		"position",
		energy_reward_finale_pos,
		0.5
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	await energy_panels_tween.finished
	await get_tree().create_timer(0.5).timeout
	
	
	# Confirm button: smooth ease in/out
	var confirm_btn_tween := create_tween()
	confirm_btn_tween.tween_property(
		confirm_btn,
		"modulate:a",
		1.0,
		1.0,
	).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	
	
	

func reset_confirm_btn_pressed() :
	request_screen.global_position = request_screen_org_pos	
	energy_till_cancel.global_position = energy_reward_org_pos
	energy_reward.global_position = energy_reward_org_pos
	
	
	
