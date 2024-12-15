extends Node2D



var shakedir := Vector2.ZERO
func shake(time = 0.3,dir := Vector2.ZERO):
	$shake.wait_time = time
	$shake.start(time)
	shakedir = dir
	


func _physics_process(delta: float) -> void:
	if(not $shake.is_stopped()):
		if(shakedir == Vector2.ZERO):
			$Camera2D.position = lerp(Vector2(randf_range(-10,10),randf_range(-10,10)),Vector2.ZERO,1 - $shake.time_left/$shake.wait_time)
		else:
			$Camera2D.position = lerp(shakedir.normalized() * randf_range(0.3,1) * shakedir,Vector2.ZERO,1 - $shake.time_left/$shake.wait_time)
