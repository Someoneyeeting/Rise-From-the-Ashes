extends Area2D



@export
var on_fire = true

func _physics_process(delta: float) -> void:
	if(not on_fire):
		turn_off()

func turn_on():
	on_fire = true
	$CPUParticles2D.emitting = true
	#$CollisionShape2D.disabled = false



func turn_off():
	on_fire = false
	$CPUParticles2D.emitting = false
	#$CollisionShape2D.disabled = true
