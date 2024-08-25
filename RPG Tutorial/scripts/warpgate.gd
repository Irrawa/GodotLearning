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
	
	if player.get_parent() == good_world_scene:
		# Player is in GoodWorld, move to BadWorld
		move_to_scene(player, good_world_scene, bad_world_scene)
	elif player.get_parent() == bad_world_scene:
		# Player is in BadWorld, move to GoodWorld
		move_to_scene(player, bad_world_scene, good_world_scene)
	else:
		print("Error: Player is not in either GoodWorld or BadWorld!")

func move_to_scene(player, current_scene, target_scene):
	if current_scene != null:
		# Disable the current scene
		current_scene.visible = false
		current_scene.set_process(false)
		current_scene.set_physics_process(false)
		current_scene.set_block_signals(true)
	else:
		print("Warning: Current scene not found!")
	
	if target_scene != null:
		# Enable the target scene
		target_scene.visible = true
		target_scene.set_process(true)
		target_scene.set_physics_process(true)
		target_scene.set_block_signals(false)
	else:
		print("Error: Target scene not found!")
		return  # Exit early if target scene is not found
	
	# Move the player to the new scene
	move_player_to_new_scene(player, current_scene, target_scene)

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

func move_player_to_new_scene(player, current_scene_root, new_scene_root):
	# Ensure the player is not null
	if player == null:
		return
	
	# Remove the player from its current parent
	if current_scene_root != null:
		current_scene_root.remove_child(player)
	
	# Add the player to the new scene's root node
	new_scene_root.add_child(player)
	
	var offset = Vector2(0, 0)
	
	# Optionally, you can set the player's position if needed
	player.global_transform.origin = new_scene_root.global_transform.origin + offset
