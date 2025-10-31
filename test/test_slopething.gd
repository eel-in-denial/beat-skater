extends Path2D

@onready var floor := $FloorGraphics

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curve.bake_interval = 10

func generate_graphics():
	if curve.point_count > 1:
		var path_points := curve.tessellate_even_length(4)
		var polygon_points: PackedVector2Array = []
		polygon_points = [
			path_points[-1] + Vector2(0, 1000), 
			Vector2(0, 1000)
		]
		polygon_points.append_array(path_points)
		floor.polygon = polygon_points
	else:
		floor.polygon = []

func set_color(color: Color):
	$FloorGraphics.color = color
