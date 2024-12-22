extends Node2D



var shakedir := Vector2.ZERO
var camera : Camera2D
var initpos := Vector2.ZERO
var targetoff := Vector2.ZERO
var curoff := Vector2.ZERO

func shake(time = 0.3,dir := Vector2.ZERO):
	initpos = camera.global_position
	$shake.wait_time = time
	$shake.start(time)
	shakedir = dir
	


func _physics_process(delta: float) -> void:
	if(not camera): return
	curoff = curoff.move_toward(targetoff,0.01)
	if(not $shake.is_stopped()):
		if(shakedir == Vector2.ZERO):
			camera.position = (initpos + curoff) + lerp(Vector2(randf_range(-10,10),randf_range(-10,10)),Vector2.ZERO,1 - $shake.time_left/$shake.wait_time)
		else:
			camera.position = (initpos + curoff) + lerp(shakedir.normalized() * randf_range(0.3,1) * shakedir,Vector2.ZERO,1 - $shake.time_left/$shake.wait_time)
	else:
		camera.position = (initpos + curoff)

func _on_move_timeout() -> void:
	targetoff = Vector2(randf_range(-10,10),randf_range(-10,10))
	$move.start(randf_range(0.3,2))
