extends Node2D



var settings = {
	"sfx" : 0,
	"music" : 100,
}


func get_sfx_audio():
	return settings["sfx"]
	

func get_music_audio():
	return settings["music"]
