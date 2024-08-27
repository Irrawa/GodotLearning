extends Node2D

# Timer node to control spawning intervals
@export var spawn_interval: float = 2.0  # Time in seconds between spawns

var spawn_timer: Timer
var maximum_enemy = 5

func get_random_position_in_area(area: Area2D) -> Vector2:
	# Get the CollisionShape2D node
	var collision_shape = area.get_node("CollisionShape2D").shape
	
	# Get the global transform of the area (to convert local to global coordinates)
	var transform = area.get_global_transform()
	
	# Get the axis-aligned bounding box (AABB) of the shape
	var aabb = collision_shape.get_rect()

	var random_position = Vector2(
		randf_range(aabb.position.x, aabb.position.x + aabb.size.x),
		randf_range(aabb.position.y, aabb.position.y + aabb.size.y)
	)
		
	return random_position

func count_current_enemy() -> int:
	var counter = 0
	var child_list = self.get_children()
	for node in child_list:
		if node.has_method("be_an_enemy"):
			counter += 1
	return counter
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize the timer
	spawn_timer = $Timer
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.one_shot = false

	# Start the spawning process
	spawn_timer.start()
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	# Get the enemy_spawn_area node
	if self.count_current_enemy() < maximum_enemy:
		var spawn_area = $enemy_spawn_area
		if spawn_area == null:
			print("Error: enemy_spawn_area node not found!")
			return
		
		# Get a random position within the spawn area
		var random_position = get_random_position_in_area(spawn_area)

		# Spawn the enemy at the random position
		var enemy_instance = preload("res://scene/enemy.tscn").instantiate()
		enemy_instance.global_position = random_position
		self.add_child(enemy_instance)
