extends Node


# components
@onready var stat_display : Node3D = $"../../StatDisplay"
@onready var parent_cell_container : CharacterBody3D = $"../.."
var player_ray_cast : RayCast3D
@onready var picked_up_sound : AudioStreamPlayer3D = $"../../Sounds/CellPickedUp"
@onready var dropped_sound : AudioStreamPlayer3D = $"../../Sounds/CellDropped"


@export var pickup_speed: float = 20.0
@export var pickup_acceleration: float = 10.0

@export var wobble_amount: float = 0.5
@export var wobble_speed: float = 1.0

@export var rotation_return_speed: float = 1.0
@export var movement_deadzone: float = 0.1


var original_rotation: Vector3


func state_start() -> void:
	# hide stat display
	
	stat_display.toggle_cell_picked_up(true)
	
	stat_display.visible = false
	picked_up_sound.play()
	
	# Remember exactly how the cell was rotated before pickup.
	original_rotation = parent_cell_container.rotation


func state_process(delta) -> void:
	
	if player_ray_cast:
		
		parent_cell_container.mutation_manager._handle_cell_picked_up()
		parent_cell_container.cell_defect_event_manager._handle_cell_picked_up(true)
		
		# Get raycast endpoint in WORLD SPACE.
		var target_pos: Vector3 = player_ray_cast.to_global(
			player_ray_cast.target_position
		)
		
		var to_target: Vector3 = (
			target_pos - parent_cell_container.global_position
		)
		
		var distance: float = to_target.length()
		
		
		if distance > movement_deadzone:
			
			# Normal movement toward raycast target.
			var speed: float = clamp(
				distance * pickup_acceleration,
				0.0,
				pickup_speed
			)
			
			var target_velocity: Vector3 = (
				to_target.normalized() * speed
			)
			
			
			# ------------------------------------------------
			# PLAYER WALKING TOWARD HELD CELL
			# ------------------------------------------------
			
			var player: CharacterBody3D = GLPlayerState.player_refrence
			
			if player:
				
				var player_velocity: Vector3 = player.velocity
				
				# Ignore vertical movement.
				player_velocity.y = 0.0
				
				var cell_direction: Vector3 = (
					parent_cell_container.global_position
					- player.global_position
				)
				
				cell_direction.y = 0.0
				
				if player_velocity.length() > 0.1 and cell_direction.length() > 0.01:
					
					player_velocity = player_velocity.normalized()
					cell_direction = cell_direction.normalized()
					
					# 1 = walking directly toward cell
					# 0 = walking perpendicular
					# -1 = walking away
					var walking_toward_cell: float = (
						player_velocity.dot(cell_direction)
					)
					
					if walking_toward_cell > 0.5:
						
						# Only add extra movement when actually
						# walking toward the cell.
						var forward_push: Vector3 = (
							player_velocity
							* player.velocity.length()
							* walking_toward_cell
						)
						
						target_velocity += (forward_push * 0.7)
			
			
			# Smoothly build momentum toward target.
			parent_cell_container.velocity = (
				parent_cell_container.velocity.lerp(
					target_velocity,
					1.0 - exp(-pickup_acceleration * delta)
				)
			)
			
			
			# ------------------------------------------------
			# ROTATION / MOMENTUM
			# ------------------------------------------------
			
			var movement_direction: Vector3 = (
				parent_cell_container.velocity
			)
			
			if movement_direction.length() > 0.1:
				
				movement_direction = movement_direction.normalized()
				
				var target_rotation := original_rotation
				
				target_rotation.x += (
					-movement_direction.z * wobble_amount
				)
				
				target_rotation.z += (
					movement_direction.x * wobble_amount
				)
				
				
				# Natural wobble.
				var time := Time.get_ticks_msec() * 0.001
				
				target_rotation.x += (
					sin(time * wobble_speed)
					* wobble_amount
					* 0.2
				)
				
				target_rotation.z += (
					cos(time * wobble_speed)
					* wobble_amount
					* 0.2
				)
				
				
				parent_cell_container.rotation = (
					parent_cell_container.rotation.lerp(
						target_rotation,
						1.0 - exp(-rotation_return_speed * delta)
					)
				)
		
		else:
			
			# Gradually stop at target.
			parent_cell_container.velocity = (
				parent_cell_container.velocity.lerp(
					Vector3.ZERO,
					1.0 - exp(-pickup_acceleration * delta)
				)
			)
			
			# Return rotation.
			parent_cell_container.rotation = (
				parent_cell_container.rotation.lerp(
					original_rotation,
					1.0 - exp(-rotation_return_speed * delta)
				)
			)
		
		parent_cell_container.move_and_slide()


func state_end() -> void:
	
	dropped_sound.play()
	
	parent_cell_container.velocity = Vector3.ZERO
	parent_cell_container.move_and_slide()
	
	# Return cleanly to previous rotation.
	parent_cell_container.rotation = original_rotation
	
	# show stat display
	stat_display.visible = true 
	
	# reset ray cast
	player_ray_cast = null
	
	parent_cell_container.cell_defect_event_manager._handle_cell_picked_up(false)
	stat_display.toggle_cell_picked_up(false)
