class_name Player
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
var wall_slide_speed : float = 300

@export
var dash_color : Color = Color.WHITE
@export
var no_dash_color : Color = Color.WHITE

@onready
var ogScale :Vector2= $PheonixBro.scale

var lunch_dir : Vector2

var last_launch : Node2D

var has_dash := false

var wall_jump = 0
var wall_jumps = 4
var was_on_floor := false
var looking_right := true
var state = ""

######jump######
func jump():
	if(wall_jump == 0):
		velocity.y = min(-jumpheight,velocity.y)
		$sounds/jump.play()
	LevelManger.start_moving()
	%cyote.stop()
	%buffer.stop()
	

func _reset_wall_jumps():
	wall_jumps = 4

func _wall_jump():
	if(wall_jumps == 0): return
	$sounds/jump.play()
	velocity.y = min(-jumpheight,velocity.y)
	velocity.x = -wall_jump * 500
	wall_jumps -= 1

func _handle_jump():
	_check_for_wall()
	if(Input.is_action_just_pressed("jump")):
		%buffer.start()
	if(wall_jump != 0 and Input.is_action_just_pressed("jump")):
		_wall_jump()
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
	if(not was_on_floor and is_on_floor()):
		$sounds/land.play()
	if(velocity.y < 0):
		velocity.y += 20
	else:
		if(wall_jump != 0):
			velocity.y = min(wall_slide_speed,velocity.y)
			velocity.y += 10
		elif(velocity.y < max_fall_speed):
			velocity.y += 40
	was_on_floor = is_on_floor()

func _handle_movement():
	var move := Input.get_action_strength("right") - Input.get_action_strength("left")
	var move_speed = move * speed
	if(move != 0):
		LevelManger.start_moving()
		if(sign(move) != sign(velocity.x)):
			move_speed *= 2.4
		else:
			if(velocity.x * move >= max_speed):
				move_speed = 0
	else:
		move_speed = -velocity.x / 2
	#print(state)
	if(is_on_floor()):
		if(is_zero_approx(velocity.x)):
			state = "idle"
		else:
			state = "running"
		velocity.x += move_speed
	else:
		if(wall_jump != 0):
			state = "wall_slide"
		else:
			if(state == "dash" or state == "falling_dash"):
				state = "falling_dash"
			else:
				if(wall_jump == 0):
					state = "falling"
		velocity.x += move_speed * 0.6
	if(not is_zero_approx(velocity.x)):
		looking_right = velocity.x > 0

func normal_move():
	last_launch = null
	
	if(is_on_floor()):
		has_dash = false
	
	_handle_falling()
	
	_handle_push_objects()
	
	_handle_movement()

##################


######Animtions######

func _handle_animation():
	var rot :float= 0
	var flip = false
	var speed :float= 1
	var sc :float = 1
	
	if(state == "idle"):
		$PheonixBro.animation = "idle"
		flip = not looking_right
	elif(state == "running"):
		$PheonixBro.animation = "running"
		speed = abs(velocity.x) / max_speed * 1
		flip = not looking_right
	elif(state == "falling"):
		$PheonixBro.animation = "falling"
		flip = not looking_right
	elif(state == "wall_slide"):
		$PheonixBro.animation = "wall_slide"
		flip = not looking_right
	elif(state == "dash"):
		$PheonixBro.animation = "dash"
		rot = velocity.angle()
	elif(state == "falling_dash"):
		$PheonixBro.animation = "dash"
		if(velocity.y > 100):
			state = "falling"
		rot = velocity.angle()
	
	
	if(state in ["idle","running"]):
		sc = lerp(1.,0.9,abs(velocity.length()/max_speed))
	elif(state in ["dash","dash_falling"]):
		sc = lerp(1.,0.6,abs(velocity.length()/ rising_speed))
	else:
		sc = max(1.,1/lerp(1.,0.6,abs(velocity.y/max_fall_speed)))
	
	
	#$PheonixBro.scale.x = lerp($PheonixBro.scale.x,$PheonixBro.scale.y if flip else -$PheonixBro.scale.y,0.7)
	#print($PheonixBro.scale.x)
	$PheonixBro.scale = Vector2(1/sc,sc) * ogScale
	$PheonixBro.flip_h = flip
	$PheonixBro.speed_scale = speed
	$PheonixBro.global_rotation = lerp($PheonixBro.global_rotation,rot,0.4)

#####rising#####
func rise():
	$sounds/dash.play()
	_reset_wall_jumps()
	$rising.start()
	$flamestime.start()
	LevelManger.dimming = 0.1
	CameraHandler.shake(0.13,lunch_dir * 60)
	$AudioStreamPlayer.play()
	Particalhandler.emit("explosion",global_position)

func _check_for_wall():
	if(is_on_floor()): _reset_wall_jumps()
	if(not is_on_wall_only()) : return
	if(Input.is_action_pressed("right")):
		for i in $walldetect/right.get_overlapping_bodies():
			if i.is_in_group("solid"):
				wall_jump = 1
				$wall_jump.start()
				break
	elif(Input.is_action_pressed("left")):
		for i in $walldetect/left.get_overlapping_bodies():
			if i.is_in_group("solid"):
				$wall_jump.start()
				wall_jump = -1
				break

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
		if i.is_in_group("fire"):
			i.turn_on()
	
func rising():
	
	state = "dash"
	velocity = -lerp(rising_finish_speed,rising_speed,$rising.time_left / $rising.wait_time) * lunch_dir
	_handle_explosions()
		
	if(get_real_velocity().length() <= 0.2):
		Particalhandler.emit("explosion",global_position)
		$rising.stop()
	if(Input.is_action_just_pressed("jump")):
		Particalhandler.emit("explosion",global_position)
		$rising.stop()
		if(wall_jump == 0):
			jump()
		else:
			_wall_jump()


func _handle_launch(i):
	lunch_dir = -Vector2.UP.rotated(i.global_rotation)
	$flames.global_rotation = i.global_rotation
	global_position = i.global_position
	rise()



################



func _physics_process(delta: float) -> void:
	if(global_position.y >= 1500):
		LevelManger.restart()
	if(not $cooldown.is_stopped()):
		return
	$flames.emitting = not $flamestime.is_stopped()
	_handle_jump()
	_handle_animation()
	_handle_dash()
	LevelManger.has_dash = has_dash
	$ColorRect.color = (dash_color if(has_dash or $rising.time_left > 0) else no_dash_color)
	
	$ColorRect2.material.set_shader_parameter("maxdis",lerp(0.4,.6,0.3/LevelManger.dimming))
	
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
		LevelManger.has_dash = true
		CameraHandler.shake(0.2)
		$sounds/dashcharge.play()
		$pause.start()
		if(velocity.y > 0):
			velocity.y /= 2
		area.take()
		await get_tree().process_frame
		get_tree().paused = true 


func _on_pause_timeout() -> void:
	get_tree().paused = false
	$sounds/afterdash.play()


func _on_wall_jump_timeout() -> void:
	wall_jump = 0
