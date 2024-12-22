extends Camera2D



func _ready() -> void:
	CameraHandler.camera = self
	CameraHandler.initpos = global_position
