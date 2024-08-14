extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func interact_with_player(player):
	var current_tree = get_tree()
	
	# Find the scenes in the current scene tree
	var good_world_scene = current_tree.current_scene.find_child("GoodWorld", true, false)
	var bad_world_scene = current_tree.current_scene.find_child("BadWorld", true, false)
	
	# Disable the GoodWorld scene
	if good_world_scene != null:
		good_world_scene.visible = false
		good_world_scene.set_process(false)
		good_world_scene.set_physics_process(false)
		good_world_scene.set_block_signals(true)
	else:
		print("Warning: GoodWorld scene not found!")
	
	# Enable the BadWorld scene
	if bad_world_scene != null:
		bad_world_scene.visible = true
		bad_world_scene.set_process(true)
		bad_world_scene.set_physics_process(true)
		bad_world_scene.set_block_signals(false)
	else:
		print("Error: BadWorld scene not found!")
		return  # Exit early if BadWorld scene is not found
	
	# Move the player to the new scene if it's valid
	if bad_world_scene != null:
		move_player_to_new_scene(player, bad_world_scene)
	else:
		print("Error: Failed to move player to BadWorld scene!")


# Disable input and interaction for all nodes in the specified scene
func disable_interaction_for_scene(scene):
	for node in scene.get_children():
		if node is Control or node is Node2D:
			node.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Ignore mouse input
			node.set_process_input(false)  # Stop processing input events
			node.set_block_signals(true)  # Block signals
		elif node is CollisionObject2D:
			node.set_deferred("disabled", true)  # Disable collisions and physics interactions
		# Recursively disable interaction for child nodes
		disable_interaction_for_scene(node)

func move_player_to_new_scene(player, new_scene_root):
	# Ensure the player is not null
	if player == null:
		return
	
	# Get the player's current parent node
	var current_parent = player.get_parent()
	
	# Remove the player from its current parent
	if current_parent != null:
		current_parent.remove_child(player)
	
	# Add the player to the new scene's root node
	new_scene_root.add_child(player)
	
	var offset = Vector2(0, 0)
	
	# Optionally, you can set the player's position if needed
	player.global_transform.origin = new_scene_root.global_transform.origin + offset
