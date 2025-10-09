extends Path2D

@onready var line := $Line2D
var on_beat_points := []
@export var initial_speed := 1000

@export var player: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curve.bake_interval = 10
	

	#player.init()
	#fuckin why this no work
func generate_graphics():
	line.points = curve.tessellate_even_length(4)

func _draw():
	var pts = curve.get_baked_points()
	for p in pts:
		draw_circle(p, 3, Color.RED)
	for b in on_beat_points:
		draw_circle(curve.sample_baked(b), 20, Color.RED)
