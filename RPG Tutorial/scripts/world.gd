extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var goodworld_instance = preload("res://scene/good_world.tscn").instantiate()
	goodworld_instance.global_position = Vector2(0, 0)
	self.add_child(goodworld_instance)
	
	var player_instance = preload("res://scene/player.tscn").instantiate()
	player_instance.global_position = Vector2(0, 0)
	goodworld_instance.add_child(player_instance)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
