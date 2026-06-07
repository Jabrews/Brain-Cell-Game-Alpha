extends Node

# componnets
@onready var tip_label : Label = $StatMesh/SubViewport/UseableItemScreen/ItemHint

func update_tip_label(text : String) :
	tip_label.text = text
