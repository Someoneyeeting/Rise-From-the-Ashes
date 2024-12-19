extends CharacterBody2D


@export
var speed : float = 2

@export
var jumpheight : float = 200

@export
var rising_speed : float = 1000

@export 
var rising_finish_speed : float = 400

@export
var max_speed : float = 300

@export
var max_fall_speed : float = 20


@export
var dash_color : Color = Color.WHITE
@export
var no_dash_color : Color = Color.WHITE


var lunch_dir : Vector2

var last_launch : Node2D

var has_dash := false


######jump######
func jump():
	velocity.y = min(-jumpheight,velocity.y)
	%cyote.stop()
	%buffer.stop()
	

func _handle_jump():
	if(Input.is_action_pressed("jump")):
		%buffer.start()
	if(is_on_floor()):
		if(velocity.y > 0):
			velocity.y = 0
		%cyote.start()
	if(%cyote.time_left > 0 and %buffer.time_left > 0):
		jump()

##################


#######move#######
func _handle_push_objects():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if(not collider): continue
		if collider.is_in_group("pushable"):
			var collision_normal = collision.get_normal()
			if abs(collision_normal.y) < 0.1: #ensuring player is not on top or bottom of the block
				collider.velocity = -collision_normal * 200 * lerp(0.6,1.0,(abs(velocity.x) / max_speed))
				#collider.move_and_slide()

func _handle_falling():
	if(velocity.y < 0):
		velocity.y += 18
	else:
		if(velocity.y < max_fall_speed):
			velocity.y += 23

func _handle_movement():
	var move := Input.get_action_strength("right") - Input.get_action_strength("left")
	var move_speed = move * speed
	if(move != 0):
		if(sign(move) != sign(velocity.x)):
			move_speed *= 2.4
		else:
			if(velocity.x * move >= max_speed):
				move_speed = 0
	else:
		move_speed = -velocity.x / 2
	
	if(is_on_floor()):
		velocity.x += move_speed
	else:
		velocity.x += move_speed * 0.6

func normal_move():
	last_launch = null
	
	if(is_on_floor()):
		has_dash = false
	
	_handle_falling()
	
	_handle_push_objects()
	
	_handle_movement()

##################


#####rising#####
func rise():
	$rising.start()
	$flamestime.start()
	CameraHandler.shake(0.13,lunch_dir * 30)
	$AudioStreamPlayer.play()
	Particalhandler.emit("explosion",global_position)

func _handle_dash():
	if(Input.is_action_just_pressed("dash")):
		$dash.start()
	if(has_dash):
		if(Input.is_action_pressed("dash")):
			lunch_dir = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),Input.get_action_strength("down") - Input.get_action_strength("up"))
			lunch_dir = -lunch_dir.normalized()
			rise()
			has_dash = false

func _handle_explosions():
	for i in $fire.get_overlapping_bodies():
		print(i.name)
		if i.is_in_group("fire"):
			i.turn_on()
	
func rising():
	
	velocity = -lerp(rising_finish_speed,rising_speed,$rising.time_left / $rising.wait_time) * lunch_dir
	_handle_explosions()
		
	if(get_real_velocity().length() <= 0.2):
		$rising.stop()
	if(Input.is_action_just_pressed("jump")):
		$rising.stop()
		jump()


func _handle_launch(i):
	lunch_dir = -Vector2.UP.rotated(i.global_rotation)
	$flames.global_rotation = i.global_rotation
	global_position = i.global_position
	rise()



################



func _physics_process(delta: float) -> void:
	$flames.emitting = not $flamestime.is_stopped()
	_handle_jump()
	
	_handle_dash()
	
	$ColorRect.color = (dash_color if(has_dash or $rising.time_left > 0) else no_dash_color)
	
	#$fire/.disabled = $rising.time_left > 0
	
	
	if($rising.is_stopped()):
		normal_move()
	else:
		rising()
		
	$minorframes.emitting = has_dash
	move_and_slide()


func _on_firedetect_area_entered(area: Area2D) -> void:
	if(area.is_in_group("fire")):
		if(area.on_fire):
			_handle_launch(area)
	if(area.is_in_group("dash")):
		has_dash = true
		CameraHandler.shake(0.2)
		get_tree().paused = true 
		$pause.start()
		if(velocity.y > 0):
			velocity.y /= 2
		area.take()


func _on_pause_timeout() -> void:
	get_tree().paused = false
