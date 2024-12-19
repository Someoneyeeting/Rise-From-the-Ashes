extends Area2D



@export
var dash_color : Color = Color.WHITE
@export
var no_dash_color : Color = Color.WHITE


func _physics_process(delta: float) -> void:
	$CollisionShape2D.disabled = not $disable.is_stopped()
	$ColorRect.color = no_dash_color if $disable.time_left > 0 else dash_color

func take():
	$disable.start()
	Particalhandler.emit("boom",global_position)
