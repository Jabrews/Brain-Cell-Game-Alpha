extends Node

@onready var spare_symbol_effects : Node = $"../SpareSymbolEffects"
@onready var handle_energy : Node = $"../../../HandleEnergy"

func _handle_disable_spare_symbols() :
	spare_symbol_effects.strength_spare_symbol = StatSpareSymbol.new('none', '')
	spare_symbol_effects.intelligence_spare_symbol = StatSpareSymbol.new('none', '')
	spare_symbol_effects.community_spare_symbol = StatSpareSymbol.new('none', '')
	
	handle_energy._update_spare_symbol_energy_used('strength', 0)
	handle_energy._update_spare_symbol_energy_used('intelligence', 0)
	handle_energy._update_spare_symbol_energy_used('community', 0)
	
	
	
	
