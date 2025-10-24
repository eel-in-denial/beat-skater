extends Node2D


@onready var sprite := $Sprite2D
@onready var camera := $Camera2D
var baked_points := []
var dt := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.play_signal.connect(play)
	Global.pause_signal.connect(pause)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Global.is_playing:
		var i: int = floor(Global.song_position/dt)
		var alpha: float = fmod(Global.song_position, dt) / dt
		var a = baked_points[i]
		var b = baked_points[i + 1]
		position = a["pos"].lerp(b["pos"], alpha)
		var tangent: Vector2 = a["tangent"].lerp(b["tangent"], alpha).normalized()
		rotation = tangent.angle()
		#if i + 2 >= baked_points.size():
			#Global.pause()
			#pause()

func _unhandled_input(event: InputEvent) -> void:   
	if event.is_action_pressed("jump"):
		jump()

func set_baked_points(points: Array):
	baked_points = points
	dt = baked_points[1]["time"] - baked_points[0]["time"] 

func play():
	camera.enabled = true

func pause():
	camera.enabled = false

func jump():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "position:y", sprite.position.y - 300, 0.3)
	tween.tween_property(sprite, "position:y", sprite.position.y, 0.3)
	
