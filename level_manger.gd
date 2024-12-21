extends Node2D



var current_level = 0

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

func get_level_name(level):
	return levelnames[level]

func load_level():
	pause()
	get_tree().change_scene_to_packed.call_deferred(levels[current_level])

func switch_level(level):
	current_level = level
	$AnimationPlayer.play("switch")

func start_music():
	if(not $AudioStreamPlayer.playing):
		$AudioStreamPlayer.play()

func stop_music():
	$AudioStreamPlayer.stop()

func restart():
	$TimerManger.restart()
	load_level()

func win():
	$TimerManger.finish(get_level_name(current_level))
	get_next()

func get_next():
	current_level += 1
	load_level()

func is_level_passed(level : int):
	return false

func get_level_time(level : int):
	return 0

func getl_level_count():
	return levels.size()

func pause():
	$TimerManger.pause()

func unpause():
	$TimerManger.unpause()
	
func start_moving():
	$TimerManger.start()
