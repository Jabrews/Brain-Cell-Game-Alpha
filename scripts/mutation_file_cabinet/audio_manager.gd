extends Node

@onready var s_cabinet_open : AudioStreamPlayer3D = $CabinetOpen
@onready var s_cabinet_close : AudioStreamPlayer3D = $CabinetClose
@onready var s_invalid_select : AudioStreamPlayer3D = $InvalidSelect
@onready var s_valid_select : AudioStreamPlayer3D = $ValidSelect
@onready var s_page_chose : AudioStreamPlayer3D = $PageChose
@onready var s_page_close : AudioStreamPlayer3D = $PageClose


func play_cabinet_open() :
	if s_cabinet_close.playing : 
		s_cabinet_close.stop()
	s_cabinet_open.play()

func play_cabinet_close(): 
	if s_cabinet_open.playing : 
		s_cabinet_open.stop()
	s_cabinet_close.play()

func play_valid() :
	s_valid_select.play()

func play_invalid() :
	s_invalid_select.play()

func play_page_chose() : 
	s_page_chose.play()

func play_page_close() :
	s_page_close.play()
