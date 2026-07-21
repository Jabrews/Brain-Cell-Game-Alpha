extends Control 

@onready var energy_till_cancel_label : Label = $EnergyTillCancel/EnergyNum
@onready var energy_reward_label : Label = $Reward/EnergyNum
@onready var header_label : Label = $"../HeaderLabel"

# offer requests
@onready var stat_request_parent : Control = $RequestScreens/StatRequest
@onready var mutation_request_parent : Control = $RequestScreens/MutationRequest

# anaimtion helper
@onready var handle_animation : Node = $HandleAnimation


func _ready() -> void:
	GLShareholderOfferState.connect('recieve_item_offer_demand', _handle_recieve_item_offer)

func _handle_recieve_item_offer(item_offer : ItemOfferDemandConstructor) :
	
	header_label.visible = false
	
	visible = true
	
	energy_till_cancel_label.text = str(item_offer.energy_left_to_claim)
	energy_reward_label.text = str(item_offer.energy_reward)
	
	
	# dealing with request screens visiblty
	stat_request_parent.visible = false
	mutation_request_parent.visible = false
	
	match item_offer.demand_type : 	
		'cell' :
			stat_request_parent.visible = true
			stat_request_parent._load_cell(item_offer.demand_cell)
		'mutation' : 	
			mutation_request_parent.visible = true
			mutation_request_parent._load_mutation(item_offer.demand_mutation)
	
	# animate
	handle_animation.load_display()
	

func _on_button_button_down() -> void:
	header_label.visible = true 
	visible = false
	
	get_parent().toggle_display_lock(false)
	
	handle_animation.reset_confirm_btn_pressed()
	

func reset_offer_request_screens() :
	stat_request_parent.visible = false
