extends CharacterBody2D


@export
var speed : float = 200

@export
var jumpheight : float = 200

@export
var rising_speed : float = 1000

@export 
var rising_finish_speed : float = 400

@export
var max_fall_speed : float = 20


var lunch_dir : Vector2
func normal_move():
	var move := Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if(velocity.y < 0):
		velocity.y += 18
	else:
		if(velocity.y < max_fall_speed):
			velocity.y += 23
		
	if(is_on_floor()):
		if(velocity.y > 0):
			velocity.y = 0
	
	if(Input.is_action_just_pressed("up") and is_on_floor()):
		velocity.y = -jumpheight
	
	if(Input.is_action_just_pressed("rise") or true):
		for i in $firedetect.get_overlapping_areas():
			if i.is_in_group("fire") and i.on_fire:
				lunch_dir = -Vector2.UP.rotated(i.global_rotation)
				$flames.global_rotation = i.global_rotation
				global_position = i.global_position
				rise()
				break
				
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.is_in_group("pushable"):
			var collision_normal = collision.get_normal()
			if abs(collision_normal.y) < 0.1: #ensuring player is not on top or bottom of the block
				collider.apply_central_force(-collision_normal * 1000)
	
	
	velocity.x = move * speed
	

func rise():
	$rising.start()
	$flamestime.start()
	CameraHandler.shake(0.1,lunch_dir * 10)
	$AudioStreamPlayer.play()
	Particalhandler.emit("explosion",global_position)

func rising():
	velocity = -lerp(rising_finish_speed,rising_speed,$rising.time_left / $rising.wait_time) * lunch_dir

func _physics_process(delta: float) -> void:
	$flames.emitting = not $flamestime.is_stopped()
	if($rising.is_stopped()):
		normal_move()
	else:
		rising()
	move_and_slide()
