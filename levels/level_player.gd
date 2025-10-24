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
	for beat in level_data["beats"]:
		beats_array.append(add_beat(Vector2(beat["pos"][0], beat["pos"][1]), beat))
	rhythm_logic.beats_array = beats_array
	Global.play(0)

func add_beat(p_1: Vector2, data: Dictionary):
	var new_beat: Beat = beat_file.instantiate()
	new_beat.initialise(p_1, data)
	add_child(new_beat)
	return new_beat

func transition_to_score():
	GameManager.change_scene("level_select")

func array_to_vector(array: Array):
	return Vector2(array[0], array[1])
