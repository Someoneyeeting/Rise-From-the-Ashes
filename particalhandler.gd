extends Node2D

var parts = {
	"explosion" : preload("res://particles/explosion.tscn"),
	"boom" : preload("res://particles/boom.tscn")
}

@onready var soundeffects = {
	"break" : $barrel_break
}

func clean():
	for i in $particles.get_children():
		if(i is GPUParticles2D):
			i = i as GPUParticles2D
			if(not i.emitting):
				i.queue_free()

func play(sound : String):
	soundeffects[sound].play()

func emit(particle,pos):
	var par :GPUParticles2D= parts[particle].instantiate()
	
	par.global_position = pos
	
	par.finished.connect(clean)
	par.emitting = true
	$particles.add_child(par)
	
