class_name TimerManger
extends Node2D


var paused := false
var timer :float=0


func get_current_time():
	pass

func save_level_time(level):
	pass

func get_total_time():
	pass

func start():
	if(paused):
		timer = 0
		unpause()
		$CanvasLayer/Label.show()

func finish(level):
	pause()
	save_level_time(level)

func restart():
	timer = 0
	pause()

func pause():
	paused = true

func unpause():
	paused = false


func _physics_process(delta: float) -> void:
	if(not paused):
		timer += delta
	
	$CanvasLayer/Label.text = str(int(timer)) + ":" + str(timer - int(timer)).substr(2,2)
