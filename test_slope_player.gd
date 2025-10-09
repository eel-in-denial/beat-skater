extends Node2D

@export var gravity := Vector2(0, 980)
@export var path: Path2D
var curve: Curve2D
var distance := 0.0 #distance along the curve
@export var initial_speed := 1000
var speed :=  0.0 #speed
var total_length := 0.0
@onready var sprite := $Sprite2D

# Called when the node enters the scene tree for the first time.

func init():
	curve = path.curve
	total_length = curve.get_baked_length()
	distance = 0.0
	speed = initial_speed
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var p_1 := curve.sample_baked(distance)
	var p_2 := curve.sample_baked(distance + 0.1)
	var tangent = (p_2 - p_1).normalized()
	var acceleration = gravity.dot(tangent)
	speed += acceleration * delta
	distance += speed * delta
	
	distance = clamp(distance, 0.0, total_length)
	
	global_position = curve.sample_baked(distance) + Vector2(0, -120) + path.global_position
	rotation = tangent.angle()
	#print(p_1, " ", p_2)

func _unhandled_input(event: InputEvent) -> void:   
	if event.is_action_pressed("jump"):
		jump()
		
func jump():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "position:y", sprite.position.y - 300, 0.3)
	tween.tween_property(sprite, "position:y", sprite.position.y, 0.3)
	
