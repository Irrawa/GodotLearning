extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().root.content_scale_factor = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	var world_scene = preload("res://scene/world.tscn") as PackedScene
	get_tree().change_scene_to_packed(world_scene)
	
