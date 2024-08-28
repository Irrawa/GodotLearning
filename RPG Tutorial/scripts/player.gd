extends CharacterBody2D

const speed = 3000

# 0 is up, 1 is right, 2 is down, 3 is left
var face_dir = 2
var is_moving = false
var is_attacking = false
var damage_begin_time = 0
var damage_end_time = 0

var attack_effect_time = 0.5
var attack_time_left = 0

var player_attack_num = 5

var interact_cd = 0.3
var interact_cd_left = interact_cd

var enemy_in_damage_zone = []

var player_params = {
	"player_level": 1,
	"player_exp": 0,
	"player_attack": 5,
	"pos_x": 0,
	"pox_y": 0
}

func _ready():
	$AnimatedSprite2D.play("front_idle")
	set_damaging_timing("front_attack", 1, 2)

func _physics_process(delta):
	player_attack(delta)
	player_interact(delta)
	inflict_enemy_damage(delta)
	player_movement(delta)
	play_anim(delta)
	
func player_movement(delta):
	
	if not is_attacking:
		if Input.is_action_pressed("ui_right"):
			velocity.x = speed * delta
			velocity.y = 0
			is_moving = true
			face_dir = 1
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -speed * delta
			velocity.y = 0
			is_moving = true
			face_dir = 3
		elif Input.is_action_pressed("ui_down"):
			velocity.x = 0
			velocity.y = speed * delta
			is_moving = true
			face_dir = 2
		elif Input.is_action_pressed("ui_up"):
			velocity.x = 0
			velocity.y = -speed * delta
			is_moving = true
			face_dir = 0
		else:
			velocity.x = 0
			velocity.y = 0
			is_moving = false
	else:
		velocity.x = 0
		velocity.y = 0
		is_moving = false
	move_and_slide()

func inflict_enemy_damage(_delta):
	if is_attacking:
		for body in enemy_in_damage_zone:
			body.take_damage(player_params["player_attack"])

func get_anim_absolute_duration(anim_name, frame_idx):
	var sprite_frames = $AnimatedSprite2D.sprite_frames
	var anim_fps = sprite_frames.get_animation_speed(anim_name)
	# var playing_speed = $AnimatedSprite2D.get_playing_speed()
	var playing_speed = 1
	var relative_duration = sprite_frames.get_frame_duration(anim_name, frame_idx)
	var frame_duration = relative_duration / (anim_fps * abs(playing_speed))
	return frame_duration

func set_damaging_timing(damage_anim_name, damage_begin_idx, damage_end_idx):
	damage_begin_time = 0
	damage_end_time = 0
	for i in range(damage_begin_idx):
		damage_begin_time += get_anim_absolute_duration(damage_anim_name, i)
		damage_end_time += get_anim_absolute_duration(damage_anim_name, i)
	for i in range(damage_begin_idx, damage_end_idx):
		damage_end_time += get_anim_absolute_duration(damage_anim_name, i)

func player_upgrade():
	var delta_level = int(player_params["player_exp"] / 10)
	player_params["player_level"] += delta_level
	player_params["player_exp"] = player_params["player_exp"] % 10
	player_params["player_attack"] += delta_level * 2
	
	print("Player Upgraded from ", player_params["player_level"] - delta_level, " to ", player_params["player_level"], "!")

func receive_exp(received_exp):
	player_params["player_exp"] += received_exp
	if int(player_params["player_exp"] / 10) >= 1:
		player_upgrade()
	
func player_attack(delta):
	if Input.is_action_pressed("character_attack"):
		attack_time_left = attack_effect_time
	else:
		if attack_effect_time > 0:
			attack_time_left -= delta
	if attack_time_left > 0:
		is_attacking = true
	else:
		is_attacking = false
		
func player_interact(delta):
	if interact_cd_left > 0:
		interact_cd_left -= delta
	if Input.is_action_pressed("character_interact") and interact_cd_left <= 0:
		# Get all bodies that are overlapping with the "touch_zone" Area2D
		var overlapping_bodies = $touch_zone.get_overlapping_bodies()
		# Iterate through all overlapping bodies
		for body in overlapping_bodies:
			# Check if the body has the function "interact_with_player"
			if body.has_method("interact_with_player"):
				# Call the "interact_with_player" function on the body
				body.interact_with_player(self)
				interact_cd_left = interact_cd
	
func play_anim(_delta):
	var anim_player = $AnimatedSprite2D
	if face_dir == 0:
		anim_player.set_flip_h(false)
		if is_attacking:
			anim_player.play("back_attack")
		else:
			if is_moving:
				anim_player.play("back_walk")
			else:
				anim_player.play("back_idle")
	elif face_dir == 1:
		anim_player.set_flip_h(false)
		if is_attacking:
			anim_player.play("side_attack")
		else:
			if is_moving:
				anim_player.play("side_walk")
			else:
				anim_player.play("side_idle")
	elif face_dir == 2:
		anim_player.set_flip_h(false)
		if is_attacking:
			anim_player.play("front_attack")
		else:
			if is_moving:
				anim_player.play("front_walk")
			else:
				anim_player.play("front_idle")
	elif face_dir == 3:
		anim_player.set_flip_h(true)
		if is_attacking:
			anim_player.play("side_attack")
		else:
			if is_moving:
				anim_player.play("side_walk")
			else:
				anim_player.play("side_idle")

func save_player_params():
	player_params["pos_x"] = global_position.x
	player_params["pos_y"] = global_position.y
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_var(player_params)
	
func load_player_params():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	player_params = file.get_var()
	global_position.x = player_params["pos_x"]
	global_position.y = player_params["pos_y"]

func _on_attack_zone_body_entered(body):
	if body.has_method("be_an_enemy"):
		enemy_in_damage_zone.append(body)

func _on_attack_zone_body_exited(body):
	if body.has_method("be_an_enemy"):
		enemy_in_damage_zone.erase(body)

func _on_save_button_button_down() -> void:
	save_player_params()
	print("Player Data saved!")


func _on_load_button_button_down() -> void:
	load_player_params()
	print("Player Data loaded!")
