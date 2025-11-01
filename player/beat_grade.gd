extends Sprite2D
class_name BeatGradeParticle

var sustained_modulation = 2

# Called when the node enters the scene tree for the first time.
func _init(image, global_pos) -> void:
	texture = image
	global_position = global_pos
	print(image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("jthjv,kghdsgry8olgdy8olfgxthh")
	position.y -= 600 * delta
	sustained_modulation -= 2 * delta
	modulate.a = min(sustained_modulation, 1)
	if modulate.a <= 0.0:
		queue_free()
