extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_tree = get_tree()
	# Find the scenes in the current scene tree
	var good_world_scene = current_tree.current_scene.find_child("GoodWorld", true, false)
	
	var player_instance = preload("res://scene/player.tscn").instantiate()
	player_instance.global_position = Vector2(0, 0)
	self.add_child(player_instance)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
