extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var adventure_ui = preload("res://scripts/adventure_ui.tscn").instantiate()
	adventure_ui.global_position = Vector2(0, 0)
	self.add_child(adventure_ui)
	
	var goodworld_instance = preload("res://scene/good_world.tscn").instantiate()
	goodworld_instance.global_position = Vector2(0, 0)
	self.add_child(goodworld_instance)
	
	var player_instance = preload("res://scene/player.tscn").instantiate()
	player_instance.global_position = Vector2(0, 0)
	goodworld_instance.add_child(player_instance)
	
	get_tree().root.content_scale_factor = 4
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
