extends Node2D

@onready var sprite := $Sprite2D
var baked_points := []
var dt := 0.0

# Called when the node enters the scene tree for the first time.

func init(data: Dictionary):
	baked_points = data["baked_points"]
	dt = data["dt"]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var i: int = floor(Global.song_position/dt)
	var alpha: float = fmod(Global.song_position, dt) / dt
	var a = baked_points[i]
	var b = baked_points[i + 1]
	global_position = a["pos"].lerp(b["pos"], alpha) + Vector2(0, -120)
	var tangent: Vector2 = a["tangent"].lerp(b["tangent"], alpha).normalized()
	rotation = tangent.angle()

func _unhandled_input(event: InputEvent) -> void:   
	if event.is_action_pressed("jump"):
		jump()
		
func jump():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "position:y", sprite.position.y - 300, 0.3)
	tween.tween_property(sprite, "position:y", sprite.position.y, 0.3)
	
