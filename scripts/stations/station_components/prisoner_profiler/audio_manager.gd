extends Node

# audio components
@onready var s_cycle_stat : AudioStreamPlayer3D = $CycleStat
@onready var s_feedback: AudioStreamPlayer3D = $FeedbackSound
@onready var s_increment : AudioStreamPlayer3D = $Increment
@onready var s_increment_hold : AudioStreamPlayer3D = $IncrementHold
@onready var s_lock_shake : AudioStreamPlayer3D = $LockShake
@onready var s_unreachable_alert : AudioStreamPlayer3D = $UnreachableAlert
@onready var s_on_off_click : AudioStreamPlayer3D = $OnOffClick
@onready var s_generate : AudioStreamPlayer3D = $Generate
@onready var s_energy_alert_beep : AudioStreamPlayer3D = $EnergyAlertBeep
@onready var s_finished_ideal_creator : AudioStreamPlayer3D = $FinishedIdealCreator
@onready var s_pole_exspand_start : AudioStreamPlayer3D = $PoleExspandStart
@onready var s_door_open : AudioStreamPlayer3D = $DoorOpen
@onready var s_door_close : AudioStreamPlayer3D = $DoorClose
@onready var s_tablet_start : AudioStreamPlayer3D = $TabletStart
@onready var s_pole_moving : AudioStreamPlayer3D = $"../OfferTablet/Poles/TabletHolderPole/PoleMoving"
@onready var s_open_tablet : AudioStreamPlayer3D =$TabletSounds/OpenTablet
@onready var s_tablet_select : AudioStreamPlayer3D = $TabletSounds/TabletSelect
@onready var s_tablet_unselect : AudioStreamPlayer3D =$TabletSounds/TabletUnselect
@onready var s_confirm_success : AudioStreamPlayer3D = $TabletSounds/ConfirmSuccess
@onready var s_confirm_failed : AudioStreamPlayer3D = $TabletSounds/ConfirmFailed
@onready var s_turn_click : AudioStreamPlayer3D = $TabletSounds/TurnClick
@onready var s_turn_alert : AudioStreamPlayer3D = $TabletSounds/TurnAlert
@onready var s_offer_vent_banging : AudioStreamPlayer3D = $TabletSounds/OfferVentBanging
@onready var s_offer_vent_open : AudioStreamPlayer3D = $TabletSounds/OfferVentOpen
@onready var s_item_showcase_btn_pressed : AudioStreamPlayer3D = $TabletSounds/ItemShowcaseBtnPressed



func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect('play_sound', _handle_play_sound)
	GLPrisonerProfilerComponentsBus.connect('display_feedback', _handle_display_feedback)

func _handle_play_sound(sound_type: String) -> void:
	match sound_type:
		"cycle_stat":
			s_cycle_stat.play()
		"feedback":
			s_feedback.play()
		"increment":
			s_increment.play()
		"increment_hold" :
			s_increment_hold.play()
		"lock_shake":
			s_lock_shake.play()
		'unreachable_alert' : 
			s_unreachable_alert.play()
		"on_off_click":
			s_on_off_click.play()
		"generate":
			s_generate.play()
		'energy_alert_beep' :
			s_energy_alert_beep.play()
		'finished_ideal_creator' :
			s_finished_ideal_creator.play()
		'pole_exspand_start' : 
			s_pole_exspand_start.play()
		'door_open' :
			s_door_open.play()
		'door_close' :
			s_door_close.play()
		'tablet_start' :			
			s_tablet_start.play()
		
		'tablet_open' : 
			s_open_tablet.play()
		'tablet_select' :
			s_tablet_select.play()
		'tablet_unselect' :
			s_tablet_unselect.play()
		'confirm_success' :
			s_confirm_success.play()
		'confirm_failed' :
			s_confirm_failed.play()
		'turn_click' :
			s_turn_click.play()
		'turn_alert' : 
			s_turn_alert.play()
		'offer_vent_banging' :		
			s_offer_vent_banging.play()
		'offer_vent_open' : 
			s_offer_vent_open.play()
		'item_showcase_btn_pressed' : 
			s_item_showcase_btn_pressed.play()
			
		# pole moving
		'start_pole_moving' :
			s_pole_moving.play()
		"stop_pole_moving":
			var fade := create_tween()
			fade.tween_property(s_pole_moving, "volume_db", -80.0, 0.3)
			await fade.finished

			s_pole_moving.stop()
			s_pole_moving.volume_db = -5.0
		
		
		
		
		_:
			push_error("Unknown sound type: " + sound_type)

func _handle_display_feedback(type : String, _data : Dictionary) : 
	
	if type == 'lock_alert' :
		return
	
	_handle_play_sound('feedback')
