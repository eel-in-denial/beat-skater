extends Node2D

@onready var rail = $Rail
@onready var outrail = $RailOutline

var beat_data
var height

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initialise(data: Dictionary, points: Array):
	beat_data = data
	height = data["height"]
	position = points[0]["pos"]
	if beat_data["duration"] > 0:
		var line_points = []
		for p in points:
			var pos = (p["pos"] - position) + p["tangent"].orthogonal() * ((height+1) * 500 - 200)
			line_points.append(pos)
		rail.points = line_points.slice(1, -1)
		outrail.points = line_points
	else:
		var line_points = [Vector2(-50, 0) + points[0]["tangent"].orthogonal() * (height+1) * 500, Vector2(50, 0) + points[0]["tangent"].orthogonal() * (height+1) * 500]
		rail.points = line_points
		outrail.points = line_points
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
