extends TileMapLayer


@export
var dashcolor : Color

@export
var nodashcolor : Color


var transforms = [
	TileSetAtlasSource.TRANSFORM_FLIP_H,
	TileSetAtlasSource.TRANSFORM_FLIP_V,
	TileSetAtlasSource.TRANSFORM_TRANSPOSE,
]

func _ready():
	pass
	#for cell in get_used_cells_by_id(1, Vector2(2,1)):
		#var trans = 0
		#for i in 3:
			#if(randi_range(0,1) == 1):
				#trans += transforms[i]
		#
		#set_cell(cell,1,Vector2(2,1),trans)
				

func _physics_process(delta: float) -> void:
	material.set_shader_parameter("clr", dashcolor if not LevelManger.has_dash else nodashcolor)
