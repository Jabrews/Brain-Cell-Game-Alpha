extends Node


@onready var hack_text_parent_node: Control = $HackTextParentNode
@onready var switch_hack_text_timer: Timer = $SwitchHackTextTimer

@export var active_text_amount: int = 6

var active_hack_texts: Array[Control] = []


func _ready() -> void:
	switch_hack_text_timer.timeout.connect(
		_handle_switch_hack_text_timer_timeout
	)

	hide_all_hack_text()
	#_start_hack_text()


func _start_hack_text() -> void:
	show_new_hack_text_batch()
	switch_hack_text_timer.start()


func _stop_hack_text() -> void:
	switch_hack_text_timer.stop()
	hide_all_hack_text()


func hide_all_hack_text() -> void:
	for hack_text_parent: Control in hack_text_parent_node.get_children():
		hack_text_parent.visible = false
		hack_text_parent._end_display()

	active_hack_texts.clear()


func _handle_switch_hack_text_timer_timeout() -> void:
	# End the previous batch.
	for active_hack_text: Control in active_hack_texts:
		active_hack_text._end_display()

	active_hack_texts.clear	()

	# Start a new batch.
	show_new_hack_text_batch()


func show_new_hack_text_batch() -> void:
	var possible_hack_texts: Array[Control] = []

	for hack_text_parent: Control in hack_text_parent_node.get_children():
		possible_hack_texts.append(hack_text_parent)

	possible_hack_texts.shuffle()

	var amount_to_show: int = min(
		active_text_amount,
		possible_hack_texts.size()
	)

	for index: int in range(amount_to_show):
		var selected_hack_text: Control = possible_hack_texts[index]

		selected_hack_text.visible = true
		selected_hack_text._start_display()

		active_hack_texts.append(selected_hack_text)
