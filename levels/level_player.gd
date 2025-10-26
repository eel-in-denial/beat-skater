extends Node2D

var beat_file = preload("res://level_assets/beat/beat.tscn")

@onready var player := $Player
@onready var rhythm_logic := $RhythmLogic
@onready var floor := $Polygon2D
#@onready var accuracy_reader := $CanvasLayer/ProgressBar
#@onready var song_pos := $CanvasLayer/Label2
#var beats: Array[Beat] = []
var header_data: Dictionary
var level_data: Dictionary

# Called when the node enters the scene tree for the first time.
func initialize_data(data: Dictionary):
	header_data = data
	level_data = Global.load_json_data(data["path"])

func _ready() -> void:
	#Global.hit_accuracy.connect(show_hit_accuracy)
	Global.song_end.connect(transition_to_score)
	load_level()

#func _physics_process(delta: float) -> void:
	#song_pos.text = str(Global.beat_position)

func load_level():
	Global.init_song(load(header_data["song_path"]), level_data["bpm"])
	var points_array = []
	points_array.append(array_to_vector(level_data["baked_points"][-1]["pos"]) + Vector2(0, 10000))
	points_array.append(Vector2(0, 10000))
	for point in level_data["baked_points"]:
		point["pos"] = array_to_vector(point["pos"])
		points_array.append(point["pos"])
		point["tangent"] = array_to_vector(point["tangent"])
	player.set_baked_points(level_data["baked_points"])
	floor.polygon = points_array
		
	var beats_array = []
	var time_interval := 0.01
	for beat in level_data["beats"]:
		var i: int = floor(beat["beat"]*Global.sec_per_beat/time_interval)
		var alpha: float = fmod(beat["beat"]*Global.sec_per_beat, time_interval) / time_interval
		var p_a = level_data["baked_points"][i]
		var p_b = level_data["baked_points"][i + 1]
		var pos = p_a["pos"].lerp(p_b["pos"], alpha)
		var length_array = []
		
		if beat["press_type"] == "hold":
			while level_data["baked_points"][i]["time"] < (beat["beat"]+ beat["duration"]) * Global.sec_per_beat:
				length_array.append(level_data["baked_points"][i]["pos"] - pos)
				i += 1
			print("khbshbkdsf")
		beats_array.append(add_beat(pos, beat, length_array))
	rhythm_logic.beats_array = beats_array
	Global.play(0)

func add_beat(p_1: Vector2, data: Dictionary, length_array: Array):
	var new_beat: Beat = beat_file.instantiate()
	add_child(new_beat)
	new_beat.initialise(p_1, data, length_array)
	return new_beat

func transition_to_score():
	GameManager.change_scene("level_select")

func array_to_vector(array: Array):
	return Vector2(array[0], array[1])
