extends Path2D

@onready var line := $Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curve.bake_interval = 10
	
	#fuckin why this no work
func generate_graphics():
	line.points = curve.tessellate_even_length(4)
