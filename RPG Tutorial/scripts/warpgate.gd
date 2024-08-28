extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func interact_with_player(player):
	var current_tree = get_tree()
	var good_world_scene = current_tree.current_scene.find_child("GoodWorld", true, false)
	var bad_world_scene = current_tree.current_scene.find_child("BadWorld", true, false)
	if bad_world_scene == null:
		bad_world_scene = preload("res://scene/bad_world.tscn").instantiate()
		bad_world_scene.global_position = Vector2(0, 0)
		current_tree.current_scene.add_child(bad_world_scene)
		move_player_to_new_scene(player, good_world_scene, bad_world_scene)
		current_tree.current_scene.remove_child(good_world_scene)
	else:
		good_world_scene = preload("res://scene/good_world.tscn").instantiate()
		good_world_scene.global_position = Vector2(0, 0)
		current_tree.current_scene.add_child(good_world_scene)
		move_player_to_new_scene(player, bad_world_scene, good_world_scene)
		current_tree.current_scene.remove_child(bad_world_scene)

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
	
