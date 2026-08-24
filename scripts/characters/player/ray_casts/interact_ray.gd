
extends RayCast3D


# Interactable pickup
var player_holding_item: bool = false
var held_item: InteractablePickup = null


# Components
@onready var ray_cast_controller_parent: Node3D = $".."
@onready var drop_item_delay_timer: Timer = $DropItemDelayTimer


func _ready() -> void:
	drop_item_delay_timer.one_shot = true
	drop_item_delay_timer.timeout.connect(
		_handle_drop_item_delay_timer_timeout
	)


func _process(_delta: float) -> void:
	var collider: Object = get_collider()

	handle_automatic_drop(collider)

	if not Input.is_action_just_pressed("interact"):
		return

	# --- DROP LOGIC ---
	if player_holding_item:
		drop_item()
		return

	# --- NO COLLIDER ---
	if collider == null:
		return

	if not collider.is_in_group("interactable"):
		return

	# --- BUTTON ---
	if collider is InteractableBtn:
		collider.handle_btn_interacted()
		return

	# --- PICKUP ---
	if collider is InteractablePickup:
		collider._on_pickup_interacted(self)

		player_holding_item = true
		held_item = collider
		
		#target_position.z = -6.0

		ray_cast_controller_parent.set_ray_mode("interact")
		return

	# --- GENERIC ---
	if collider.has_method("_handle_interacted"):
		collider._handle_interacted()


func handle_automatic_drop(collider: Object) -> void:
	if not player_holding_item:
		drop_item_delay_timer.stop()
		return

	# The held item is still inside the raycast.
	if collider == held_item:
		drop_item_delay_timer.stop()
		return

	# Start only one delayed drop check.
	if drop_item_delay_timer.is_stopped():
		drop_item_delay_timer.start()


func _handle_drop_item_delay_timer_timeout() -> void:
	if not player_holding_item:
		return

	if held_item == null:
		return

	# Check the current collider after the delay.
	var current_collider: Object = get_collider()

	if current_collider != held_item:
		drop_item()


func drop_item() -> void:
	
	#target_position.z = -4.0
	
	drop_item_delay_timer.stop()

	if held_item != null:
		held_item._on_pickup_interacted(null)

	player_holding_item = false
	held_item = null

	ray_cast_controller_parent.set_ray_mode("none")
