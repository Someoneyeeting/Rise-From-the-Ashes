extends CharacterBody2D


var prevspeed :float= 0
var to_break := false

func _physics_process(delta: float) -> void:
	velocity.y += 30
	#if(get_real_velocity().y > 0):
		#get_real_velocity().x /= 2
	if(get_real_velocity().y >= 800):
		to_break = true
	if(get_real_velocity().y <= 3 and to_break):
		explode()
	prevspeed = get_real_velocity().y
	velocity.x /= 1.4
	move_and_slide()



func explode():
	
	CameraHandler.shake()
	for i in $Area2D.get_overlapping_areas():
		if(i.is_in_group("fire")):
			i.turn_on()
		Particalhandler.emit("explosion",global_position)
	queue_free.call_deferred()
