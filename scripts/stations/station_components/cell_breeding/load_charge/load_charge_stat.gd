extends Node

var left_charge_stat : String = 'none'
var right_charge_stat : String = 'none'
var left_stat_direction : String = 'none'
var right_stat_direction : String = 'none'

@onready var direction_btn_controller : Node = $"../DirectionBtnController"


func _process(delta: float) -> void: 
	if Input.is_action_just_pressed('debug1'): 
		load_charge_stat()


func _handle_new_energy_seat_stat_chosen(side : String, stat : String, valid : bool) :
	
	match side : 	
		'left' :
			if not valid : 			
				left_charge_stat = 'none'
			else  :
				left_charge_stat = stat
			
		'right' :
			if not valid : 			
				right_charge_stat= 'none'
			else  :
				right_charge_stat = stat

func _handle_new_direction_chosen(side : String, direction : String) :
	
	match side : 	
		'left' :
			left_stat_direction = direction 
		'right' :
			right_stat_direction = direction 

func load_charge_stat() : 
	
	print('left : ', left_charge_stat, ' ', left_stat_direction)	
	print('right : ', right_charge_stat, ' ', right_stat_direction)	
	
	#if left_charge_stat != 'none' :	
		#if left_stat_direction != 'none' :
			#pass
		#else : 
			#pass
	#else : 
		#pass
	#
	#if right_charge_stat != 'none' :
		#if right_stat_direction != 'none' :
			#return
		#else :
			#pass
	#else : 
		#pass
	#
	#
#
	#
#
#
		#
	#
	#
