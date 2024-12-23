class_name TimerManger
extends Node2D


var paused := false
var timer :float=0

var times = {}

const TIMESFILE := "user://times.save"

func save_times():
	var save_file = FileAccess.open(TIMESFILE, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(times))
	save_file.close()

func load_times():
	if(not FileAccess.file_exists(TIMESFILE)):
		save_times()
	var save_file = FileAccess.open(TIMESFILE,FileAccess.READ)
	var json = JSON.new()
	json.parse(save_file.get_line())
	
	times = json.data
	
	save_file.close()


func get_current_time():
	return timer


func save_level_time(level):
	if(not is_passed_level(level) or get_level_best_time(level) > timer):
		times[LevelManger.get_level_name(level)] = get_current_time()
	save_times()

func get_total_time():
	var total :float= 0
	for i in times.values():
		total += i
	return total

func get_level_best_time(level):
	if(LevelManger.get_level_name(level) in times):
		return times[LevelManger.get_level_name(level)]
	else:
		return -1

func is_passed_level(level):
	return get_level_best_time(level) != -1

func start():
	if(paused):
		timer = 0
		unpause()
		if(is_passed_level(LevelManger.current_level)):
			$CanvasLayer/Label.show()

func finish(level):
	pause()
	save_level_time(level)

func clear_times():
	times = {}
	save_times()

func restart():
	timer = 0
	$CanvasLayer/Label.hide()
	pause()

func pause():
	paused = true

func unpause():
	paused = false


func _ready() -> void:
	load_times()

func _physics_process(delta: float) -> void:
	if(not paused):
		timer += delta
	
	if(LevelManger.current_level == -1):
		return
	#
	#if(is_passed_level(LevelManger.current_level)):
		#print(get_level_best_time(LevelManger.current_level))
	
	$CanvasLayer/Label.text = str(int(timer)) + ":" + str(timer - int(timer)).substr(2,2)
