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
	
	if(Input.is_action_just_pressed("up")):
		velocity.y = -jumpheight
	
	if(Input.is_action_just_pressed("rise")):
		for i in $firedetect.get_overlapping_areas():
			if i.is_in_group("fire"):
				lunch_dir = -Vector2.UP.rotated(i.global_rotation)
				$flames.global_rotation = i.global_rotation
				global_position = i.global_position
				rise()
				break
	
	
	velocity.x = move * speed
	

func rise():
	$rising.start()
	$flamestime.start()
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
