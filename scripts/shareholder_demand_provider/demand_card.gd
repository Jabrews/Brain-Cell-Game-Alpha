extends TextureRect

# components
@onready var type_image : TextureRect = $TypeImage
@onready var card_hover : TextureRect = $CardHover
@onready var flavor_text : Label = $FlavorText
# type img textures
@onready var effects_defect_img : Texture = preload("res://models/shareholder_demand_provider/effects_defect.png")
@onready var effects_prisoner_img : Texture = preload("res://models/shareholder_demand_provider/prisoner_effect.png")
@onready var parent_shareholder_demand_provider : Node3D = $"../.."

var designated_demand_item : DemandItem

var starting_pos : Vector2
var up_down_tween : Tween

func _ready() -> void:

	await get_tree().process_frame

	starting_pos = position

	mouse_entered.connect(_handle_mouse_entered)
	mouse_exited.connect(_handle_mouse_exited)

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed('attack') :	
		if card_hover.visible :
			up_down_tween.kill()
			# reset position. this is important for when card re-appears, getting it in the right pos
			position = starting_pos
			parent_shareholder_demand_provider._handle_card_picked(self)

func update(demand_item : DemandItem) :
	
	position = starting_pos
	modulate.a = 1.0
	
	designated_demand_item = demand_item 
	
	match designated_demand_item.demand_type:
		'prisoner' :
			type_image.texture = effects_prisoner_img
		'defect' :
			type_image.texture = effects_defect_img
		
	flavor_text.text = designated_demand_item.demand_text
	
	

func _handle_mouse_entered():

	card_hover.visible = true

	if up_down_tween:
		up_down_tween.kill()

	position = starting_pos

	up_down_tween = create_tween()
	up_down_tween.set_loops()

	up_down_tween.tween_property(
		self,
		"position",
		starting_pos + Vector2(0, -5),
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	up_down_tween.tween_property(
		self,
		"position",
		starting_pos + Vector2(0, 5),
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _handle_mouse_exited():

	card_hover.visible = false

	if up_down_tween:
		up_down_tween.kill()
		up_down_tween = null

	position = starting_pos
