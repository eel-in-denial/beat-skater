extends Node2D

var beat_file = preload("res://level_assets/beat/beat.tscn")
var rail_file = preload("res://level_assets/rail/rail.tscn")
@export var hit_windows_enabled: bool = false
@onready var player := $Player
@onready var rhythm_logic := $RhythmLogic
@onready var floor := $Polygon2D
#@onready var accuracy_reader := $CanvasLayer/ProgressBar
@onready var song_pos := $CanvasLayer/Label2
#var beats: Array[Beat] = []
var header_data: Dictionary
var level_data: Dictionary
var graphics_data: Dictionary

var baked_graphical_points = []

# Called when the node enters the scene tree for the first time.
func initialize_data(data: Dictionary):
	header_data = data
	level_data = Global.load_json_data(data["path"])
	graphics_data = Global.load_json_data(data["graphics_path"])

func _ready() -> void:
	print("testing")
	#Global.hit_accuracy.connect(show_hit_accuracy)
	Global.song_end.connect(transition_to_score)
	load_level()

func _physics_process(delta: float) -> void:
	song_pos.text = str(Global.beat_position)

func load_level():
	Global.bpm = level_data["bpm"]
	var points_array = []
	points_array.append(array_to_vector(level_data["baked_points"][-1]["pos"]) + Vector2(0, 10000))
	points_array.append(Vector2(0, 10000))
	for point in level_data["baked_points"]:
		point["pos"] = array_to_vector(point["pos"])
		points_array.append(point["pos"])
		point["tangent"] = array_to_vector(point["tangent"])
	player.set_baked_points(level_data["baked_points"])
	for i in range(0, level_data["baked_points"].size(), 10):
		baked_graphical_points.append(level_data["baked_points"][i])
	floor.polygon = points_array
		
	var beats_array = []
	var time_interval := 0.01
	for beat in level_data["beats"]:
		var i: int = floor(beat["beat"]*Global.sec_per_beat/time_interval)
		var alpha: float = fmod(beat["beat"]*Global.sec_per_beat, time_interval) / time_interval
		var p_a = level_data["baked_points"][i]
		var p_b = level_data["baked_points"][i + 1]
		var pos = p_a["pos"].lerp(p_b["pos"], alpha)
		var tangent = p_a["tangent"].lerp(p_b["tangent"], alpha).normalized()
		var length_array = []
		var hit_window = []
		
		if beat["press_type"] == "hold":
			while level_data["baked_points"][i]["time"] < (beat["beat"]+ beat["duration"]) * Global.sec_per_beat:
				length_array.append(level_data["baked_points"][i]["pos"] - pos)
				i += 1
			print("khbshbkdsf")
		if hit_windows_enabled:
			hit_window = level_data["baked_points"].slice(
				floor((beat["beat"]*Global.sec_per_beat - Global.ok_time_window)/time_interval), 
				floor((beat["beat"]*Global.sec_per_beat + Global.ok_time_window)/time_interval)
			)
			for h_i in range(hit_window.size()):
				hit_window[h_i] =  hit_window[h_i]["pos"] - pos
		beats_array.append(add_beat({"pos": pos, "tangent": tangent}, beat, length_array, hit_window))
	
	var rails_array = []
	for r in level_data["objects"]:
		var i: int = floor(r["beat"]*Global.sec_per_beat/time_interval)
		var alpha: float = fmod(r["beat"]*Global.sec_per_beat, time_interval) / time_interval
		var p_a = level_data["baked_points"][i]
		var p_b = level_data["baked_points"][i + 1]
		var pos = p_a["pos"].lerp(p_b["pos"], alpha)
		var tangent = p_a["tangent"].lerp(p_b["tangent"], alpha).normalized()
		var p_array = []
		if r["duration"] > 0:
			while level_data["baked_points"][i]["time"] < (r["beat"]+ r["duration"]) * Global.sec_per_beat:
				p_array.append(level_data["baked_points"][i])
				i += 1
		else:
			points_array.append(level_data["baked_points"][i])
		rails_array.append(add_rail(r, p_array))
	rhythm_logic.beats_array = beats_array
	rhythm_logic.rails_array = rails_array
	load_graphics()
	Global.play(0, 4)

func load_graphics():
	RenderingServer.set_default_clear_color(Color(graphics_data["bg_colour"]))
	$Polygon2D.color = Color(graphics_data["slope_colour"])
	var mountainlayer = $Parallax2D
	var mountains = [load("res://background_assets/mountain_1.png"), load("res://background_assets/mountain_2.png"), load("res://background_assets/mountain_3.png")]
	var distance = 0
	var height = 0
	var baked_idx = 0
	for i in range(100):
		var dice = randi_range(0, 2)
		var instance = Sprite2D.new()
		instance.texture = mountains[dice]
		mountainlayer.add_child(instance)
		instance.position = Vector2(distance, baked_graphical_points[baked_idx]["pos"].y - randf_range(0, 200))
		var scale = randf_range(0.9, 1)
		instance.scale = Vector2(scale, scale)
		distance += randf_range(300, 600)
		while baked_graphical_points[baked_idx]["pos"].x < distance:
			baked_idx += 1
		
func add_beat(point_data: Dictionary, data: Dictionary, length_array: Array, hit_window = []):
	var new_beat: Beat = beat_file.instantiate()
	add_child(new_beat)
	new_beat.initialise(point_data, data, length_array, hit_window)
	return new_beat

func add_rail(data: Dictionary, point_data: Array):
	var new_rail = rail_file.instantiate()
	add_child(new_rail)
	new_rail.initialise(data, point_data)
	return new_rail

func transition_to_score():
	GameManager.change_scene("level_select")

func array_to_vector(array: Array):
	return Vector2(array[0], array[1])
