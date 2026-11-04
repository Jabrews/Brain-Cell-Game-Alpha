extends Node

# components
@onready var light_mesh: MeshInstance3D = $Light/LightMesh
@onready var light: SpotLight3D = $Light/Light
@onready var light_flash_timer: Timer = $Light/LightFlashTimer
@onready var light_flash_duration_timer: Timer = $Light/LightFlashDurationTimer
@onready var jar_curr_amount_label: Label3D = $JarLabels/CurrAmount
# helper component
@onready var refresh_jar_items : Node = $RefreshJarItems

const LIGHT_GREEN_COLOR: Color = Color.GREEN
const LIGHT_OFF_COLOR: Color = Color.WHITE_SMOKE

var _light_is_on: bool = false
var _light_mesh_material: StandardMaterial3D


func _process(_delta: float) -> void: 
	if Input.is_action_just_pressed('debug1') :
		var index : int = 1
		GLJarComponentBus.emit_signal('remove_jar_item', GLJarComponentBus.jar_items[index])
		

func _ready() -> void:
	GLJarComponentBus.add_jar_item.connect(_handle_add_jar_item)
	GLJarComponentBus.remove_jar_item.connect(_handle_remove_jar_item)

	light_flash_timer.timeout.connect(_handle_light_flash_timer)
	light_flash_duration_timer.timeout.connect(_handle_light_flash_duration_timeout)

	light_flash_timer.one_shot = false
	light_flash_duration_timer.one_shot = true

	var active_material := light_mesh.get_active_material(0) as StandardMaterial3D
	if active_material != null:
		_light_mesh_material = active_material.duplicate() as StandardMaterial3D
		light_mesh.set_surface_override_material(0, _light_mesh_material)

	_set_light_state(false)
	_update_jar_amount_label()


func _handle_add_jar_item(jar_item: JarItem) -> void:
	GLJarComponentBus.jar_items.append(jar_item)
	_update_jar_amount_label()
	_flash_added_cell_light()
	
	refresh_jar_items._refresh()


func _handle_remove_jar_item(jar_item: JarItem) -> void:

	GLJarComponentBus.jar_items.erase(jar_item)
	_update_jar_amount_label()
	
	refresh_jar_items._refresh()


func _update_jar_amount_label() -> void:
	jar_curr_amount_label.text = str(GLJarComponentBus.jar_items.size())


#### LIGHT ####
func _flash_added_cell_light() -> void:
	light_flash_duration_timer.start()
	light_flash_timer.start()
	_handle_light_flash_timer()


func _handle_light_flash_timer() -> void:
	_set_light_state(not _light_is_on)


func _handle_light_flash_duration_timeout() -> void:
	light_flash_timer.stop()
	_set_light_state(false)


func _set_light_state(is_on: bool) -> void:
	_light_is_on = is_on

	var color := LIGHT_GREEN_COLOR if is_on else LIGHT_OFF_COLOR
	light.visible = is_on
	light.light_color = color

	if _light_mesh_material != null:
		_light_mesh_material.albedo_color = color
#################
