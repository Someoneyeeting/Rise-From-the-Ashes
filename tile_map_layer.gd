extends TileMapLayer


@export
var dashcolor : Color

@export
var nodashcolor : Color

func _physics_process(delta: float) -> void:
	material.set_shader_parameter("clr", dashcolor if not LevelManger.has_dash else nodashcolor)
