extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_tree = get_tree()
	# Find the scenes in the current scene tree
	var good_world_scene = current_tree.current_scene.find_child("GoodWorld", true, false)
	var bad_world_scene = current_tree.current_scene.find_child("BadWorld", true, false)

	# Disable the GoodWorld scene
	if good_world_scene != null:
		good_world_scene.visible = true
		good_world_scene.set_process(true)
		good_world_scene.set_physics_process(true)
		good_world_scene.set_block_signals(false)
	else:
		print("Warning: GoodWorld scene not found!")

	# Enable the BadWorld scene
	if bad_world_scene != null:
		bad_world_scene.visible = false
		bad_world_scene.set_process(false)
		bad_world_scene.set_physics_process(false)
		bad_world_scene.set_block_signals(true)
	else:
		print("Error: BadWorld scene not found!")
		return  # Exit early if BadWorld scene is not found


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
