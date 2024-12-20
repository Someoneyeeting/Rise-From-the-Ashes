extends Node2D

var parts = {
	"explosion" : preload("res://particles/explosion.tscn"),
	"boom" : preload("res://particles/boom.tscn")
}

func clean():
	for i in get_children():
		i = i as GPUParticles2D
		if(not i.emitting):
			i.queue_free()

func emit(particle,pos):
	var par :GPUParticles2D= parts[particle].instantiate()
	
	par.global_position = pos
	
	par.finished.connect(clean)
	par.emitting = true
	add_child(par)
	
