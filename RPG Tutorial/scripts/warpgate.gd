extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func interact_with_player(player):
	print("Interact Okay!")
	var current_tree = get_tree()
	
	var new_scene = current_tree.root.find_node("BadWorld", true, false)
	if new_scene != null:
		move_player_to_new_scene(player, new_scene)
	else:
		print("Error: BadWorld scene not found!")

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
	
	# Optionally, you can set the player's position if needed
	player.global_transform.origin = Vector2(0, 0)
