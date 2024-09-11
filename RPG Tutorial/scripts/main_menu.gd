extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().root.content_scale_factor = 1
	get_tree().root.set_content_scale_size(Global.global_info["sys"]["resolution"])
	if not Global.global_info["sys"]["full_screen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	var world_scene = preload("res://scene/world.tscn") as PackedScene
	get_tree().change_scene_to_packed(world_scene)

func _on_button_2_button_up() -> void:
	var settings_scene = preload("res://scene/settings.tscn").instantiate()
	self.add_child(settings_scene)
