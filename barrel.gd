extends CharacterBody2D


var prevspeed :float= 0

func _physics_process(delta: float) -> void:
	velocity.y += 30
	#if(get_real_velocity().y > 0):
		#get_real_velocity().x /= 2
	if(prevspeed - get_real_velocity().y >= 900):
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
