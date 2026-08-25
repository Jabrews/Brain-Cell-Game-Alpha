extends Node


var saved_root_directory: String = (
	"res://debug/admin_panel/saved_admin_roots/"
)

func _save(
	admin_panel_root: AdminPanelRoot
) -> void:
	
	
	if not admin_panel_root:
		return
	
	## get rid of non needing info ##
	if not GameAdminPanel.save_updater_admin_batch_mutation: 
		admin_panel_root.admin_batch_mutation = {} 
	if not GameAdminPanel.save_random_mutation_event : 
		admin_panel_root.admin_random_mutation_event = []
	if not GameAdminPanel.save_defect_event : 
		admin_panel_root.admin_defect_event = []
	
	
	# Create the folder if it does not exist.
	if not DirAccess.dir_exists_absolute(saved_root_directory):
		var directory_error: Error = (
			DirAccess.make_dir_recursive_absolute(
				saved_root_directory
			)
		)

		if directory_error != OK:
			push_error(
				"Could not create save directory. Error: %s"
				% directory_error
			)
			return

	# Example:
	var safe_date: String = (
		admin_panel_root.date_created
		.replace(":", "-")
		.replace(" ", "_")
	)

	var file_name: String = "%s-%s.json" % [
		admin_panel_root.id,
		safe_date
	]

	var full_path: String = (
		saved_root_directory + file_name
	)

	var root_dictionary: Dictionary = (
		admin_panel_root.to_dictionary()
	)

	var json_string: String = JSON.stringify(
		root_dictionary,
		"\t"
	)

	var file: FileAccess = FileAccess.open(
		full_path,
		FileAccess.WRITE
	)

	if file == null:
		push_error(
			"Could not open save file: %s | Error: %s"
			% [
				full_path,
				FileAccess.get_open_error()
			]
		)
		return

	file.store_string(json_string)

	print("Saved admin panel root: ", full_path)
