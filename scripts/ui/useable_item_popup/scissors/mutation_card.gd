extends Control

# components
@onready var mutation_icon : TextureRect =$MutationIcon
@onready var question_mark_sprite : = $QuestionMarkSprite
@onready var get_mutation_symbol : Node = $"../GetMutationSymbol"
@onready var highlight : TextureRect = $Highlight
@onready var red_bg : ColorRect = $RedBG

# parent component
@onready var parent_useable_item_popup : Control = $"../../.."


var loaded_mutation : BrainCellMutation 
var hover_active : bool = false

func _ready() -> void:
	red_bg.connect('mouse_entered', _handle_mouse_entered)
	red_bg.connect('mouse_exited', _handle_mouse_exited)

func _process(_delta: float) -> void: 
	if hover_active : 
		if Input.is_action_just_pressed('attack') :
			parent_useable_item_popup._handle_pop_up_mutation_selected(loaded_mutation.type)
			
	
func _handle_mouse_entered() :	
	if loaded_mutation : 
		highlight.visible = true
		hover_active = true

func _handle_mouse_exited() :
	if loaded_mutation : 
		highlight.visible = false
		hover_active = false

	
func _load_mutation(mutation : BrainCellMutation) : 
	loaded_mutation = mutation
	if mutation.hidden : 
		question_mark_sprite.visible = true
		mutation_icon.visible = false
	else : 
		question_mark_sprite.visible = false 
		mutation_icon.visible = true
		var symbol_texture : Texture = get_mutation_symbol.get_symbol(mutation.type)
		mutation_icon.texture = symbol_texture
