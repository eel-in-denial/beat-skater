extends Node2D


@onready var sprite := $Sprite2D
@onready var camera := $Camera2D
var baked_points := []
var dt := 0.0
var jump_points := []
var max_jump_height := 400.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.play_signal.connect(play)
	Global.pause_signal.connect(pause)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_playing:
		var curr_pos = position_at_time(Global.song_position)
		if jump_points:
			position = jump_points[0]
			jump_points.pop_front()
		else:
			position = curr_pos
		var tangent: Vector2 = tangent_at_time(Global.song_position)
		sprite.rotation = tangent.angle()
		if Input.is_action_just_pressed("jump"):
			jump()
		$Polygon2D.position = curr_pos
		#if i + 2 >= baked_points.size():
			#Global.pause()
			#pause()
		#queue_redraw()

func position_at_time(song_pos: float):
	var i: int = floor(song_pos/dt)
	var alpha: float = fmod(song_pos, dt) / dt
	if i+1 < baked_points.size():
		var a = baked_points[i]
		var b = baked_points[i + 1]
		var pos = a["pos"].lerp(b["pos"], alpha)
		return pos
	else:
		return Vector2.ZERO

func tangent_at_time(song_pos: float)-> Vector2:
	var i: int = floor(song_pos/dt)
	var alpha: float = fmod(song_pos, dt) / dt
	if i+1 < baked_points.size():
		var a = baked_points[i]
		var b = baked_points[i + 1]
		var tangent = a["tangent"].lerp(b["tangent"], alpha).normalized()
		return tangent
	else:
		return Vector2.ZERO

func set_baked_points(points: Array):
	baked_points = points
	dt = baked_points[1]["time"] - baked_points[0]["time"] 

func play():
	camera.enabled = true

func pause():
	camera.enabled = false

func jump():
	var jump_position_0 = position_at_time(Global.song_position + Global.sec_per_beat/2)
	var jump_position = position_at_time(Global.song_position + Global.sec_per_beat/2) + tangent_at_time(Global.song_position + Global.sec_per_beat/2).orthogonal() * max_jump_height
	var land_position = position_at_time(Global.song_position + Global.sec_per_beat)
	var i: int = floor(Global.song_position/dt)
	var i_1: int = floor((Global.song_position + Global.sec_per_beat/2)/dt)
	var i_2: int = floor((Global.song_position + Global.sec_per_beat)/dt)
	jump_points = []
	for jump_i in range(i_2 - i):
		var alpha: float = float(jump_i)/(i_2 - i)
		var jump_pos = position.lerp(land_position, alpha)
		var jump_alpha: float = -pow(alpha*2-1, 2)+1
		var jump_height = jump_position_0.lerp(jump_position, jump_alpha) - jump_position_0
		jump_pos += jump_height 
		jump_points.append(jump_pos)
	$Line2D.points = jump_points
	$Polygon2D2.position = land_position
#func _draw() -> void:
	#draw_circle(jump_position, 5, Color.RED)
	#draw_circle(land_position, 5, Color.RED)
	#for p in jump_points:
		#draw_circle(p, 5, Color.ANTIQUE_WHITE)
	##print(jump_points)
