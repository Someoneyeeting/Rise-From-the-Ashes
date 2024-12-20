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
	restart()

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("restart")):
		restart()

func get_level_name(level):
	return levelnames[level]

func load_level(level : int):
	get_tree().change_scene_to_packed.call_deferred(levels[level])
	
func restart():
	$TimerManger.restart()
	load_level(current_level)
	
func win():
	$TimerManger.finish(get_level_name(current_level))
	get_next()

func get_next():
	current_level += 1
	load_level(current_level)

func is_level_passed(level : int):
	pass

func get_level_time(level : int):
	pass

func pause():
	$TimerManger.pause()

func unpause():
	$TimerManger.unpause()
