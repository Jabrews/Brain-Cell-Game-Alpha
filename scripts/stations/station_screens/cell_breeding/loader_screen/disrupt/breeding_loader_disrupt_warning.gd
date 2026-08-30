extends Control

@export var active_room_name : String

# component timer
@onready var flash_delay_timer : Timer = $FlashDelayTimer

@onready var seat_cell_loading : Node2D = $"../SeatCellLoading"
@onready var new_cell_preview : Node2D  = $"../NewCellPreview"
@onready var disrupt_manager_loader : Control = $"../DisruptorManagerSeatLoading"
@onready var disrupt_manager_new_cell : Control = $"../DisruptorManagerNewCell"




func _ready() -> void:
	GLMutationDisruptState.connect('disrupt_incoming', _handle_disrupt_incoming)
	GLMutationDisruptState.connect('disrupt_ended', _handle_disrupt_ended)
	flash_delay_timer.connect('timeout', _handle_flash_delay_timer_timeout)
	
func _handle_disrupt_incoming(room_name : String) :
	
	# instead of checking if one manager is valid find the screen thats active	
	
	var active_disrupt_manager : Control = get_active_screen()
	
	if active_disrupt_manager.displaying_interuption : 
		return
	
	if active_room_name == room_name :
		if flash_delay_timer.is_stopped() :
			flash_delay_timer.start()
			visible = true
			
		
	else :
		flash_delay_timer.stop()
		visible = false

func get_active_screen() -> Control:
	
	if seat_cell_loading.visible == true :
		return disrupt_manager_loader
	elif new_cell_preview.visible == true : 
		return disrupt_manager_new_cell
	else : 
		push_error('unable to find either screen visible')
		return null
	

func _handle_disrupt_ended() :
	flash_delay_timer.stop()
	visible = false

func _handle_flash_delay_timer_timeout() :
	visible = !visible
	
