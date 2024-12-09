extends CharacterBody2D


@export
var speed : float = 200

@export
var jumpheight : float = 200

@export
var rising_speed : float = 1000

@export 
var rising_finish_speed : float = 400

func normal_move():
	var move := Input.get_action_strength("right") - Input.get_action_strength("left")
	
	velocity.y += 10.3
	if(is_on_floor()):
		if(velocity.y > 0):
			velocity.y = 0
	
	if(Input.is_action_just_pressed("up")):
		velocity.y = -jumpheight
	
	if(Input.is_action_just_pressed("rise")):
		rise()
	
	velocity.x = move * speed
	

func rise():
	$rising.start()
	$flamestime.start()

func rising():
	velocity.x = 0
	velocity.y = -lerp(rising_finish_speed,rising_speed,$rising.time_left / $rising.wait_time)

func _physics_process(delta: float) -> void:
	$flames.emitting = not $flamestime.is_stopped()
	if($rising.is_stopped()):
		normal_move()
	else:
		rising()
	move_and_slide()
