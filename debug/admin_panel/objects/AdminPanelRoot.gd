extends Node

class_name AdminPanelRoot


var id: int
var date_created: String
var admin_batch_mutation: Dictionary[int, AdminBatchMutation] = {}
var admin_random_mutation_event: Array[AdminRandomMutationEvent] = []
var admin_defect_event: Array[AdminDefectEvent] = []


@warning_ignore("shadowed_variable")
func _init(
	id: int = 0,
	date_created: String = "",
	admin_batch_mutation: Dictionary[int, AdminBatchMutation] = {},
	admin_random_mutation_event: Array[AdminRandomMutationEvent] = [],
	admin_defect_event: Array[AdminDefectEvent] = []
) -> void:
	self.id = id
	self.date_created = date_created
	self.admin_batch_mutation = admin_batch_mutation
	self.admin_random_mutation_event = admin_random_mutation_event
	self.admin_defect_event = admin_defect_event


func _to_string() -> String:
	return "[admin panel root] | id: %s | date created: %s | batch mutations: %s | random mutation events: %s | defect events: %s" % [
		id,
		date_created,
		admin_batch_mutation,
		admin_random_mutation_event,
		admin_defect_event
	]


func to_dictionary() -> Dictionary:
	var serialized_batches: Dictionary = {}
	var serialized_random_events: Array[Dictionary] = []
	var serialized_defect_events: Array[Dictionary] = []


	### Admin batch mutations ###
	for turn: int in admin_batch_mutation:
		var batch: AdminBatchMutation = admin_batch_mutation[turn]

		if batch == null:
			continue

		if batch.is_default():
			continue

		serialized_batches[turn] = batch.to_dictionary()


	### Admin random mutation events ###
	for random_event_record: AdminRandomMutationEvent in admin_random_mutation_event:
		if random_event_record == null:
			continue

		if random_event_record.is_default():
			continue

		serialized_random_events.append(
			random_event_record.to_dictionary()
		)


	### Admin defect events ###
	for defect_event_record: AdminDefectEvent in admin_defect_event:
		if defect_event_record == null:
			continue

		if defect_event_record.is_default():
			continue

		serialized_defect_events.append(
			defect_event_record.to_dictionary()
		)


	return {
		"id": id,
		"date_created": date_created,
		"admin_batch_mutation": serialized_batches,
		"admin_random_mutation_event": serialized_random_events,
		"admin_defect_event": serialized_defect_events
	}


static func from_dictionary(data: Dictionary) -> AdminPanelRoot:
	var loaded_batches: Dictionary[int, AdminBatchMutation] = {}
	var loaded_random_events: Array[AdminRandomMutationEvent] = []
	var loaded_defect_events: Array[AdminDefectEvent] = []


	### Load admin batch mutations ###
	var raw_batches: Variant = data.get(
		"admin_batch_mutation",
		{}
	)

	if raw_batches is Dictionary:
		for raw_turn: Variant in raw_batches:
			var raw_batch: Variant = raw_batches[raw_turn]

			if raw_batch is not Dictionary:
				continue

			loaded_batches[int(raw_turn)] = (
				AdminBatchMutation.from_dictionary(raw_batch)
			)


	### Load admin random mutation events ###
	var raw_random_events: Variant = data.get(
		"admin_random_mutation_event",
		[]
	)

	if raw_random_events is Array:
		for raw_event: Variant in raw_random_events:
			if raw_event is not Dictionary:
				continue

			loaded_random_events.append(
				AdminRandomMutationEvent.from_dictionary(raw_event)
			)


	### Load admin defect events ###
	var raw_defect_events: Variant = data.get(
		"admin_defect_event",
		[]
	)

	if raw_defect_events is Array:
		for raw_event: Variant in raw_defect_events:
			if raw_event is not Dictionary:
				continue

			loaded_defect_events.append(
				AdminDefectEvent.from_dictionary(raw_event)
			)


	return AdminPanelRoot.new(
		int(data.get("id", 0)),
		str(data.get("date_created", "")),
		loaded_batches,
		loaded_random_events,
		loaded_defect_events
	)


func is_default() -> bool:
	return (
		id == 0
		and date_created.is_empty()
		and admin_batch_mutation.is_empty()
		and admin_random_mutation_event.is_empty()
		and admin_defect_event.is_empty()
	)
