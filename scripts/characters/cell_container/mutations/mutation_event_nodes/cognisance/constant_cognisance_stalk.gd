extends MutationNode

# components
# timers
@onready var start_delay_timer : Timer = $StartDelay
@onready var initate_walk_delay_timer : Timer = $InitateWalkDelay
@onready var auto_fall_delay_timer : Timer = $AutoFallDelay
@onready var fall_delay_timer : Timer = $FallDelay
# area
@onready var detect_player_hitbox_area : Area3D = $DetectPlayerHitboxArea
# label
@onready var debug_fell_over_label : Label3D = $DebugFellOverLabel
# sounds 
@onready var s_looked_at : AudioStreamPlayer3D = $LookedAt
@onready var s_walking : AudioStreamPlayer3D = $Walking

# component helpers
@onready var move_towards_player : Node = $MoveTowardsPlayer
@onready var detect_player_looking : Node = $DetectPlayerLooking

@export var start_delay_wait_time = 10.0
@export var initate_walk_min_time : float = 5.0
@export var initate_walk_max_time : float = 20.0
@export var fall_delay_min_time : float = 180
@export var fall_delay_max_time : float = 240


func _ready_overide() :
	
	random_event = false
	stop_on_pickup = false
	
	# timer signals
	initate_walk_delay_timer.connect('timeout', _handle_initate_walk_delay_timer_timeout)	
	auto_fall_delay_timer.connect('timeout', _handle_auto_fall_delay_timer_timeout)
	fall_delay_timer.connect('timeout', _handle_fall_delay_timer_timeout)
	
	
func _start() :
	
	unhide_mutation()
	
	# startup delay timer
	start_delay_timer.wait_time = start_delay_wait_time
	start_delay_timer.start()	
	await start_delay_timer.timeout
	
	# start initate walk delay timer
	_start_initate_walk_delay_timer()
	

func _start_initate_walk_delay_timer() :
	var ran_wait_time = randf_range(initate_walk_min_time, initate_walk_max_time)
	
	initate_walk_delay_timer.wait_time = ran_wait_time
	initate_walk_delay_timer.start()

func _start_fall_delay_timer() :
	var ran_wait_time = randf_range(fall_delay_min_time, fall_delay_max_time)
	
	fall_delay_timer.wait_time = ran_wait_time
	fall_delay_timer.start()
	
### TIME OUT SIGNALS ###	
func _handle_initate_walk_delay_timer_timeout() :
	move_towards_player._toggle(true)
	detect_player_looking._toggle(true)
	s_walking.play()
	detect_player_hitbox_area.monitoring = true
	
	auto_fall_delay_timer.start()

func _handle_auto_fall_delay_timer_timeout() :
	_handle_cell_looked_at()

func _handle_fall_delay_timer_timeout() :
	_start_initate_walk_delay_timer()
	
	debug_fell_over_label.visible = false
	
#########################
	
func _handle_cell_looked_at(): 	
	
	# sounds	
	s_walking.stop()
	s_looked_at.play()
	
	detect_player_hitbox_area.monitoring = false
	
	move_towards_player._toggle(false)	
	detect_player_looking._toggle(false)
	
	auto_fall_delay_timer.stop()
	
	debug_fell_over_label.visible = true
	
	_start_fall_delay_timer()
	
func _stop() :
	pass
