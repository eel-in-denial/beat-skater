extends Node2D
class_name  Rail

@onready var rail = $Rail
@onready var outrail = $RailOutline

var beat_data
var height := 1
var time_pos := 0.0
var hold_time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initialise(data: Dictionary, points: Array):
	beat_data = data
	height = data["height"]
	time_pos = data["beat"] * Global.sec_per_beat
	hold_time = data["duration"] * Global.sec_per_beat
	position = points[0]["pos"]
	if beat_data["duration"] > 0:
		var line_points = []
		for p in points:
			var pos = (p["pos"] - position) + p["tangent"].orthogonal() * ((height+1) * 400 - 30)
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
