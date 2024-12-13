extends RigidBody2D


var prevspeed :float= 0

func _physics_process(delta: float) -> void:
	if(linear_velocity.y > 0):
		linear_velocity.x /= 2
	if(prevspeed - linear_velocity.y >= 600):
		for i in $Area2D.get_overlapping_areas():
			if(i.is_in_group("fire")):
				#print("aaaa")
				i.turn_on()
		Particalhandler.emit("explosion",global_position)
		queue_free.call_deferred()
	prevspeed = linear_velocity.y
