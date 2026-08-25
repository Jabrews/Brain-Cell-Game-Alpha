extends StaticBody3D

# components
@onready var lifespan_timer: Timer = $Lifespan
@onready var bubble_sprite: AnimatedSprite3D = $BubbleSprite
@onready var s_pop : AudioStreamPlayer3D = $Pop
@onready var detect_ceiling_ray : RayCast3D = $DetectCeilingRay

@export var sprite_color: Color
@export var life_span_wait_time: float = 3.0
@export var float_speed: float = 2.0

var killing : bool = false

var orginal_postion_z : float
var horizontal_movement_tween : Tween

func _ready() -> void:
	
	await get_tree().process_frame
	
	orginal_postion_z = global_position.z
	
	lifespan_timer.wait_time = life_span_wait_time
	lifespan_timer.start()
	
	bubble_sprite.modulate = sprite_color
	
	lifespan_timer.connect('timeout', _handle_lifespan_timer_timeout)
	
	toggle_horziontal_movement(true)
	
	
func _process(delta: float) -> void:
	
	if killing :
		return
	
	global_position.y += float_speed * delta
	
	if detect_ceiling_ray.is_colliding() :
		kill_bubble()


func _handle_lifespan_timer_timeout() -> void:
	kill_bubble()

func kill_bubble() :
	
	if killing : 	
		return
	
	killing = true
	
	toggle_horziontal_movement(false)
	s_pop.play()
	bubble_sprite.play('Pop')
	await bubble_sprite.animation_finished
	self.queue_free()

func toggle_horziontal_movement(toggle_value : bool) :
	
	
	if horizontal_movement_tween :
		horizontal_movement_tween.kill()
		
	if toggle_value :
		horizontal_movement_tween = create_tween()
		horizontal_movement_tween.set_loops()
		
		horizontal_movement_tween.tween_property(
			self,
			'position:x',
			position.x + 0.1,
			0.5
		)
		
		horizontal_movement_tween.parallel().tween_property(
			self,
			'position:z',
			orginal_postion_z + 0.1,
			0.5
		)
		
		horizontal_movement_tween.tween_property(
			self,
			'position:x',
			position.x,
			0.5
		)
		
		horizontal_movement_tween.parallel().tween_property(
			self,
			'position:z',
			orginal_postion_z,
			0.5
		)
		
		horizontal_movement_tween.tween_property(
			self,
			'position:x',
			position.x - 0.1,
			0.5
		)
		
		horizontal_movement_tween.parallel().tween_property(
			self,
			'position:z',
			orginal_postion_z - 0.1,
			0.5
		)

			
	
