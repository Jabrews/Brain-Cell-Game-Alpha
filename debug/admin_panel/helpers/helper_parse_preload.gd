extends Node


func _parse_preload(
	preload_json_path: String
) -> AdminPanelRoot:
	var resolved_path: String = preload_json_path

	####################
	# RESOLVE UID PATH #
	####################

	if preload_json_path.begins_with("uid://"):
		var file_uid: int = ResourceUID.text_to_id(
			preload_json_path
		)

		if file_uid == ResourceUID.INVALID_ID:
			push_error(
				"Invalid file UID: %s"
				% preload_json_path
			)
			return null

		if not ResourceUID.has_id(file_uid):
			push_error(
				"Godot does not recognize this file UID: %s"
				% preload_json_path
			)
			return null

		resolved_path = ResourceUID.get_id_path(file_uid)

	######################
	# VALIDATE FILE TYPE #
	######################

	if resolved_path.get_extension().to_lower() != "json":
		push_error(
			"Admin panel file must be JSON. UID resolved to: %s"
			% resolved_path
		)
		return null

	##################
	# OPEN JSON FILE #
	##################

	if not FileAccess.file_exists(resolved_path):
		push_error(
			"JSON file does not exist: %s"
			% resolved_path
		)
		return null

	var file: FileAccess = FileAccess.open(
		resolved_path,
		FileAccess.READ
	)

	if file == null:
		push_error(
			"Could not open JSON file: %s | Error: %s"
			% [
				resolved_path,
				FileAccess.get_open_error()
			]
		)
		return null

	##################
	# READ FILE TEXT #
	##################

	var json_string: String = file.get_as_text()

	if json_string.strip_edges().is_empty():
		push_error(
			"JSON file is empty: %s"
			% resolved_path
		)
		return null

	print(
		"First 20 characters: ",
		json_string.left(20)
	)

	##############
	# PARSE JSON #
	##############

	var json: JSON = JSON.new()
	var parse_error: Error = json.parse(json_string)

	if parse_error != OK:
		push_error(
			"JSON parse error: %s | File: %s | Line: %s"
			% [
				json.get_error_message(),
				resolved_path,
				json.get_error_line()
			]
		)
		return null

	var data_received: Variant = json.data

	# JSON objects become Godot Dictionaries.
	if not data_received is Dictionary:
		push_error(
			"Admin panel JSON root must be an object."
		)
		return null

	var data_dictionary: Dictionary = data_received

	###########################
	# CREATE ADMIN ROOT OBJECT #
	###########################

	var admin_panel_root: AdminPanelRoot = (
		AdminPanelRoot.from_dictionary(
			data_dictionary
		)
	)


	return admin_panel_root
