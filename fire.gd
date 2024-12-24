extends Area2D



@export
var on_fire = true
var t : float = 0.


func _physics_process(delta: float) -> void:
	if(not on_fire):
		turn_off()
		t += delta
		$CampfirePlatform/CampfireOrb.position.y = sin(t * 1.5) * 5 - 20
		$CampfirePlatform/CampfireOrb.position.x = sin(t * 4) * 2

func turn_on():
	on_fire = true
	$CPUParticles2D.emitting = true
	$CampfirePlatform.hide()
	Particalhandler.emit("explosion",$CampfirePlatform/CampfireOrb.global_position)
	#$CollisionShape2D.disabled = false



func turn_off():
	on_fire = false
	$CPUParticles2D.emitting = false
	$CampfirePlatform.show()
	#$CollisionShape2D.disabled = true
