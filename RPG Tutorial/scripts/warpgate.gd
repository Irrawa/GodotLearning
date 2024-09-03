extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func interact_with_player(player):
	var current_scene = player.get_parent()
	var base_scene = current_scene.get_parent()
	var current_world_name = current_scene.name  # Get the current scene's name
	var target_scene_path = ""

	# Determine the target scene based on the current scene
	if current_world_name == "GoodWorld":
		target_scene_path = "res://scene/bad_world.tscn"
	elif current_world_name == "BadWorld":
		target_scene_path = "res://scene/good_world.tscn"
	else:
		print("Current Scene Name: ", current_world_name)
		print("Unknown scene. This node should be in either GoodWorld or BadWorld.")
		return

	# Load the target scene
	var target_scene = load(target_scene_path).instantiate()
	target_scene.global_position = Vector2(0, 0)  # Adjust the position as needed
	
	current_scene.remove_child(player)
	target_scene.add_child(player)
	base_scene.add_child(target_scene)
	current_scene.queue_free()  # Queue the old scene for deletion
	
