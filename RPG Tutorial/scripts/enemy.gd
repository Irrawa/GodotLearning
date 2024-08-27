extends CharacterBody2D

var SPEED = 20
var wander_timer = 0
var idle_timer = randf_range(1, 2)
var is_player_near = false
var player_body = null
var is_moving = false
var is_idle = true
var face_dir = 2

var is_dying = false
var dying_timer = 0

var health = 300

var self_exp = 1
var exp_given = false

@onready
var detection_area = $detection_area

@onready
var animation_player = $AnimatedSprite2D


func _ready():
	randomize()

func _physics_process(delta):

	# Handle movement and detection.
	handle_movement(delta)
	handle_death(delta)
	move_and_slide()
	play_animation()
	

func handle_death(delta):
	if is_dying:
		dying_timer += delta
	if dying_timer > 2:
		queue_free()

func handle_movement(delta):
	# Check for player in detection area and set movement.
	if is_player_near:
		is_idle = false
		is_moving = true
		chase_player(delta)
	else:
		wander(delta)

func wander(delta):
	if is_idle and idle_timer > 0:
		idle_timer -= delta
		return
		
	if is_idle and idle_timer <= 0:
		is_idle = false
		is_moving = true
		velocity.x = randf_range(-1, 1) * SPEED
		velocity.y = randf_range(-1, 1) * SPEED
		wander_timer = randf_range(1, 2)
		update_direction(velocity)
		return
	
	if is_moving and wander_timer > 0:
		wander_timer -= delta
		return 
		
	if is_moving and wander_timer <= 0:
		is_idle = true
		is_moving = false
		velocity.x = 0
		velocity.y = 0
		idle_timer = randf_range(1, 2)
		return

func chase_player(_delta):
	var direction = (player_body.global_position - global_position).normalized()
	if (player_body.global_position - global_position).length_squared() < 300:
		velocity = Vector2.ZERO
	else:
		velocity = direction * SPEED
		update_direction(velocity)
	
func update_direction(v):
	if v.y <= 0 and abs(v.x) <= abs(v.y):
		face_dir = 0
		return
	elif v.x > 0 and abs(v.x) > abs(v.y):
		face_dir = 1
		return
	elif v.y > 0 and abs(v.x) <= abs(v.y):
		face_dir = 2
		return
	elif v.x < 0 and abs(v.x) > abs(v.y):
		face_dir = 3

func play_animation():
	if is_dying:
		SPEED = 0
		animation_player.play("death")
	else:
		if face_dir == 0:
			animation_player.set_flip_h(false)
			if is_idle:
				animation_player.play("back_idle")
			elif is_moving:
				animation_player.play("back_walk")
		elif face_dir == 1:
			animation_player.set_flip_h(false)
			if is_idle:
				animation_player.play("side_idle")
			elif is_moving:
				animation_player.play("side_walk")
		elif face_dir == 2:
			animation_player.set_flip_h(false)
			if is_idle:
				animation_player.play("front_idle")
			elif is_moving:
				animation_player.play("front_walk")
		elif face_dir == 3:
			animation_player.set_flip_h(true)
			if is_idle:
				animation_player.play("side_idle")
			elif is_moving:
				animation_player.play("side_walk")
			
func take_damage(player_attack_num):
	health -= player_attack_num
	if health <= 0:
		self.death()

func death():
	is_dying = true
	SPEED = 0
	$CollisionShape2D.queue_free()
	if player_body != null and not exp_given:
		player_body.receive_exp(self_exp)
		exp_given = true

func be_an_enemy():
	pass

# Signal connections from the detection area to detect the player.
func _on_detection_area_body_entered(body):
	if "player" in body.name.to_lower():
		is_player_near = true
		player_body = body

func _on_detection_area_body_exited(body):
	if "player" in body.name.to_lower():
		is_player_near = false
		

	
