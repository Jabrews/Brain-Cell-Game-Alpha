extends Node


var saved_root_directory : String = 'res://debug/admin_panel/saved_admin_roots/'

func _create_inital() -> AdminPanelRoot : 
	
	var next_id: int = get_length_of_saved_roots() + 1
	
	return AdminPanelRoot.new(
		next_id,
		Time.get_date_string_from_system(),
		TESTDATA.new('blue')
	)
	
	

func get_length_of_saved_roots() -> int:
	if not DirAccess.dir_exists_absolute(saved_root_directory):
		return 0

	var current_length: int = 0
	var saved_files: PackedStringArray = (
		DirAccess.get_files_at(saved_root_directory)
	)

	for file_name: String in saved_files:
		# Only count JSON save files.
		if file_name.get_extension().to_lower() == "json":
			current_length += 1

	return current_length

	
	


	
	
