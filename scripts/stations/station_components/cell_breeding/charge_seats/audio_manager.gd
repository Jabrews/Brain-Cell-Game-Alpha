extends Node


@onready var s_cycle_sound : AudioStreamPlayer3D = $CycleStat
@onready var s_invalid_stat : AudioStreamPlayer3D = $InvalidStat

func play_cycle() :
	s_cycle_sound.play()

func play_invalid_stat() :
	s_invalid_stat.play()
