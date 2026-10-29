extends Node

# components
@onready var stat_defect_rate_labels : Array[Label] = [
	$"../../DefectRateDisplay/StrengthDefectRate/DeathRatePercantLabel",
	$"../../DefectRateDisplay/IntelligenceDefectRate/DeathRatePercantLabel",
	$"../../DefectRateDisplay/CommunityDefectRate/DeathRatePercantLabel"
]
@onready var total_defect_rate_label : Label = $"../../DefectRateDisplay/TotalDefectRate/DeathRatePercantLabel"
@onready var total_defect_rate_symbol : TextureRect = $"../../DefectRateDisplay/TotalDefectRate/DefectRateSymbol"

var total_defect_rate_tween: Tween
var total_defect_symbol_original_modulate: Color
var total_defect_symbol_original_scale: Vector2


func _ready() -> void:
	total_defect_symbol_original_modulate = total_defect_rate_symbol.modulate
	total_defect_symbol_original_scale = total_defect_rate_symbol.scale


func _display(prisoner_card: PrisonerOfferCard) -> void:
	var stats: Array[PrisonerCardStat] = [
		prisoner_card.strength,
		prisoner_card.intelligence,
		prisoner_card.community
	]

	for index in range(stats.size()):
		var stat := stats[index]
		var rate: int = stat.defect_rate if stat.enabled else 0
		stat_defect_rate_labels[index].text = str(rate) + "%"

	total_defect_rate_label.text = str(prisoner_card.total_defect_rate) + "%"
	_toggle_total_defect_flash(prisoner_card.total_defect_rate > 50)


func _toggle_total_defect_flash(toggle_value: bool) -> void:
	if total_defect_rate_tween:
		total_defect_rate_tween.kill()
		total_defect_rate_tween = null

	total_defect_rate_symbol.modulate = total_defect_symbol_original_modulate
	total_defect_rate_symbol.scale = total_defect_symbol_original_scale

	if not toggle_value:
		return

	total_defect_rate_tween = create_tween()
	total_defect_rate_tween.set_loops()
	total_defect_rate_tween.set_trans(Tween.TRANS_SINE)
	total_defect_rate_tween.set_ease(Tween.EASE_IN_OUT)

	total_defect_rate_tween.tween_property(
		total_defect_rate_symbol,
		"modulate",
		Color.WHITE,
		0.3
	)
	total_defect_rate_tween.parallel().tween_property(
		total_defect_rate_symbol,
		"scale",
		total_defect_symbol_original_scale * 1.2,
		0.3
	)

	total_defect_rate_tween.tween_property(
		total_defect_rate_symbol,
		"modulate",
		total_defect_symbol_original_modulate,
		0.3
	)
	total_defect_rate_tween.parallel().tween_property(
		total_defect_rate_symbol,
		"scale",
		total_defect_symbol_original_scale,
		0.3
	)
