extends Path2D

@onready var line := $Line2D
var on_beat_points := []
@export var initial_speed := 2000
@export var gravity := Vector2(0, 980)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var time = 0.0
	var distance = 0.0
	var time_interval := 0.1
	curve.bake_interval = 10
	line.points = curve.tessellate_even_length(4)
	var total_length = curve.get_baked_length()
	var speed = initial_speed
	var next_beat := 0.0
	while time < 60:
		var p_1 := curve.sample_baked(distance)
		var p_2 := curve.sample_baked(distance + 0.1)
		var tangent = (p_2 - p_1).normalized()
		var acceleration = gravity.dot(tangent)
		speed += acceleration * time_interval
		distance += speed * time_interval
		
		distance = clamp(distance, 0.0, total_length)
		if abs(time - next_beat) < time_interval:
			on_beat_points.append(distance)
			next_beat += 60.0/100.0
		time += time_interval
	
func _draw():
	var pts = curve.get_baked_points()
	for p in pts:
		draw_circle(p, 3, Color.RED)
	
	for b in on_beat_points:
		draw_circle(curve.sample_baked(b), 20, Color.RED)
