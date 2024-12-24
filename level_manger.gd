extends Node2D


signal end

var current_level = -1

var has_dash := false

var levels = [
	[preload("res://levels/firstfr.tscn"),"firstfr"],
	[preload("res://levels/first.tscn"),"first"],
	[preload("res://levels/node_2d.tscn"),"doubleboost"],
	[preload("res://levels/walljump.tscn"),"walljump"],
	[preload("res://levels/chain.tscn"),"chain"],
	[preload("res://levels/testklvl.tscn"),"test"],
]


var dimming : float = 1.

func _ready() -> void:
	#restart()
	get_tree().current_scene.queue_free()
	#$AudioStreamPlayer.play()

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("restart")):
		restart()
	
	if(event.is_action_pressed("fullscreen")):
		if(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _physics_process(delta: float) -> void:
	dimming = lerp(dimming,1.,0.3)
	$CanvasLayer/effects.material.set_shader_parameter("dimming",dimming)

func get_level_name(level):
	return levels[level][1]

func get_current_level_name():
	return get_level_name(current_level)

func load_level():
	$TimerManger.restart()
	get_tree().change_scene_to_packed.call_deferred(levels[current_level][0])

func get_time_as_string(time):
	return $TimerManger.get_time_as_string(time)

func get_time_as_string_minutes(time):
	
	var seconds :int= int(time)
	var minutes :int= seconds / 60
	seconds %= 60
	var ms := int(str(time - int(time)).substr(2,2))
	
	return "%02d:%02d:%02d" % [minutes,seconds,ms]

func get_total_time():
	return $TimerManger.get_total_time()

func switch_level(level,speed = 0.55):
	if(get_tree().current_scene):
		get_tree().current_scene.queue_free.call_deferred()
	%clevel.text = str(level + 1) + " / " + str(get_levels_count())
	
	
	%clevel.set_global_position(Vector2(1280,720)/2 - (%clevel.get_rect().size / 2))
	unpause()
	%clevel2.text = $TimerManger.get_time_as_string($TimerManger.get_level_best_time(level))
	current_level = level
	$AnimationPlayer.speed_scale = speed
	$AnimationPlayer.play("switch")
	

func clear_times():
	$TimerManger.clear_times()

func start_music():
	if(not $AudioStreamPlayer.playing):
		$AudioStreamPlayer.play()

func stop_music():
	$AudioStreamPlayer.stop()

func restart():
	if($AnimationPlayer.is_playing() or current_level == -1): return
	$TimerManger.restart()
	switch_level(current_level,1.)

func win():
	$TimerManger.finish(current_level)
	#pause()
	if(current_level == get_levels_count() - 1):
		vectory()
	else:
		get_next()

func vectory():
	$AudioStreamPlayer.stop()
	pause()
	$vectory.play()
	
	await $vectory.finished
	
	get_tree().current_scene.queue_free()
	MenuManger.open_menu("times")
	current_level = -1
func get_next():
	switch_level(current_level + 1)

func is_level_passed(level : int):
	return $TimerManger.is_passed_level(level)

func get_level_time(level : int):
	return $TimerManger.get_level_best_time(level)

func get_levels_count():
	return levels.size()

func pause():
	$TimerManger.pause()
	get_tree().paused = true

func unpause():
	$TimerManger.unpause()
	get_tree().paused = false
	
func start_moving():
	$TimerManger.start()
