extends Label



var t = 0;

func _process(delta: float) -> void:
	t += delta
	
	text = str(int(t)) + ":" + str(t - int(t)).substr(2,2)
