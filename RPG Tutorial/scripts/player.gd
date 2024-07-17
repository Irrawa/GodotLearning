extends CharacterBody2D

const speed = 3000

# 0 is up, 1 is right, 2 is down, 3 is left
var face_dir = 2
var is_moving = false
var is_attacking = false
var damage_begin_time = 0
var damage_end_time = 0

func _ready():
	$AnimatedSprite2D.play("front_idle")
	set_damaging_timing("front_attack", 1, 2)

func _physics_process(delta):
	player_attack()
	player_movement(delta)
	play_anim(is_moving, is_attacking)
	
func player_movement(delta):
	
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
	move_and_slide()
	
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
	
	
func player_attack():
	if Input.is_action_pressed("character_attack"):
		is_attacking = true
		print(damage_begin_time, damage_end_time)
	else:
		is_attacking = false
	
	
func play_anim(is_moving, is_attacking):
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
			

		
	
	
