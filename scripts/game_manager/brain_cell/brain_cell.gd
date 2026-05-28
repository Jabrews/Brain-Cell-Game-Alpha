class_name BrainCell

var name : String

var strength: float
var intelligence: float
var community: float

var life_span: int

var strength_defect: float
var intelligence_defect: float
var community_defect: float

var strength_hidden: bool
var intelligence_hidden: bool
var community_hidden: bool

var is_target_cell : bool
var turn_into_flesh_bug : bool



@warning_ignore("shadowed_variable")
func _init(
	name : String,
	strength: float,
	intelligence: float,
	community: float,
	life_span: int,
	strength_defect: float = 0.0,
	intelligence_defect: float = 0.0,
	community_defect: float = 0.0,
	strength_hidden: bool = false,
	intelligence_hidden: bool = false,
	community_hidden: bool = false,
	is_target_cell : bool = false,
	turn_into_flesh_bug : bool = false,
):
	self.name = name
	
	self.strength = strength
	self.intelligence = intelligence
	self.community = community
	self.life_span = life_span

	self.strength_defect = strength_defect
	self.intelligence_defect = intelligence_defect
	self.community_defect = community_defect

	self.strength_hidden = strength_hidden
	self.intelligence_hidden = intelligence_hidden
	self.community_hidden = community_hidden

	self.is_target_cell = is_target_cell
	self.turn_into_flesh_bug  = turn_into_flesh_bug

	
func _to_string() -> String:
	@warning_ignore("incompatible_ternary")
	return "S:%s I:%s C:%s | life:%s | name:%s" % [
		strength if not strength_hidden else "?",
		intelligence if not intelligence_hidden else "?",
		community if not community_hidden else "?",
		life_span,
		name	
	]
