extends Node2D

var beat = preload("res://level_assets/beat/beat.tscn")

@onready var backgroud: Sprite2D = $Background
@onready var floor := $Floor
@onready var path := $LevelPath
@onready var player := $test_slope_player
@onready var accuracy_reader := $CanvasLayer/ProgressBar
@onready var song_pos := $CanvasLayer/Label2
#var beats: Array[Beat] = []
var json_path: String
var level_data: Dictionary

var player_initial_speed := 0.0
var player_jump_height := 500
var player_screen_position := Vector2(480.0, 0)
var gravity := Vector2(0, 980)

var baked_points := []

# Called when the node enters the scene tree for the first time.
func initialize_data(data := {"json_path": ""}):
	json_path = data["json_path"]

func _ready() -> void:
	Global.hit_accuracy.connect(show_hit_accuracy)
	Global.song_end.connect(transition_to_score)
	level_data = Global.load_json_data(json_path)
	load_level()

func _physics_process(delta: float) -> void:
	song_pos.text = str(Global.beat_position)

func load_level():
	player_initial_speed = 700
	Global.new_level(load(level_data["song_path"]), level_data["bpm"])
	
	generate_slopes()
	path.generate_graphics()
	bake_level()


func generate_slopes():
	var noise := FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.0004    # controls hill width (smaller = wider hills)
	noise.fractal_octaves = 2   # adds detail
	for x in range(0, 200000, 50):  # x step controls resolution
		var y = 300 + noise.get_noise_1d(float(x)) * 150
		path.curve.add_point(Vector2(x, y))
		

func bake_level():
	var time = 0.0
	var distance = 0.0
	var time_interval := 0.01
	var total_length = path.curve.get_baked_length()
	var speed = player_initial_speed
	var i := 0
	var next_beat: float = level_data["beats"][i]["beat"] * Global.sec_per_beat 
	var num_of_beats: int = level_data["beats"].size()
	while time < Global.song_duration:
		var p_1: Vector2 = path.curve.sample_baked(distance)
		var p_2: Vector2 = path.curve.sample_baked(distance + 0.1)
		var tangent = (p_2 - p_1).normalized()
		var acceleration = gravity.dot(tangent)
		speed += acceleration * time_interval
		distance += speed * time_interval
		distance = clamp(distance, 0.0, total_length)
		
		baked_points.append({"time": time, "pos": p_1, "speed": speed, "tangent": tangent})
		if abs(time - next_beat) < time_interval:
			if i < num_of_beats:
				var new_beat: Beat = beat.instantiate()
				new_beat.initialise(p_1, level_data["beats"][i])
				add_child(new_beat)
			if i < num_of_beats - 1:
				i += 1
				next_beat = level_data["beats"][i]["beat"] * Global.sec_per_beat
		time += time_interval
	var dict = {
		"dt": time_interval,
		"baked_points": baked_points
	}
	player.init(dict)

func transition_to_score():
	GameManager.change_scene("level_select")

func show_hit_accuracy(value: float):
	accuracy_reader.value = 50 + value*500
	$CanvasLayer/Label.text = str(value)
