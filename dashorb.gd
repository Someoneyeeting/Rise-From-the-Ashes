extends Area2D



func _physics_process(delta: float) -> void:
	$CollisionShape2D.disabled = not $disable.is_stopped()


func take():
	$disable.start()
