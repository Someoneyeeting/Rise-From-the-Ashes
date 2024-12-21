extends Node2D



var current_level = -1

var has_dash := false

var levels = [
	preload("res://node_2d.tscn"),
	preload("res://chain.tscn")
]

var levelnames = [
	"test",
	"chain"
]

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

func get_level_name(level):
	return levelnames[level]

func load_level():
	pause()
	$TimerManger.restart()
	get_tree().change_scene_to_packed.call_deferred(levels[current_level])

func switch_level(level):
	%clevel.text = str(level + 1) + " / " + str(get_levels_count())
	
	%clevel.set_global_position(Vector2(1280,720)/2 - (%clevel.get_rect().size / 2))
	%clevel.visible = not (level == current_level)
	current_level = level
	$AnimationPlayer.play("switch")

func start_music():
	if(not $AudioStreamPlayer.playing):
		$AudioStreamPlayer.play()

func stop_music():
	$AudioStreamPlayer.stop()

func restart():
	$TimerManger.restart()
	switch_level(current_level)

func win():
	$TimerManger.finish(get_level_name(current_level))
	get_next()

func get_next():
	switch_level(current_level + 1)

func is_level_passed(level : int):
	return false

func get_level_time(level : int):
	return 0

func get_levels_count():
	return levels.size()

func pause():
	$TimerManger.pause()

func unpause():
	$TimerManger.unpause()
	
func start_moving():
	$TimerManger.start()
