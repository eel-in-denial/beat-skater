extends Node2D

var beat = preload("res://level_assets/beat/beat.tscn")
#var floor = preload("")
var beat_distance := 0.0


@onready var backgroud: Sprite2D = $Background
@onready var floor := $Floor
@onready var player := $Player
@onready var accuracy_reader := $CanvasLayer/ProgressBar
var beats: Array[Beat] = []
var json_path: String
var level_data: Dictionary


# Called when the node enters the scene tree for the first time.
func initialize_data(data := {"json_path": ""}):
	json_path = data["json_path"]

func _ready() -> void:
	Global.hit_accuracy.connect(show_hit_accuracy)
	Global.song_end.connect(transition_to_score)
	level_data = load_json_data(json_path)
	load_level()
	

func load_json_data(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		print("Error: JSON file not found at path:", path)
		return {}
	
	var file = FileAccess.open(path, FileAccess.READ)
	
	var content = file.get_as_text()
	file.close()
	
	var parsed_json = JSON.parse_string(content)
	
	if parsed_json is Dictionary:
		return parsed_json
	else:
		print("Error parsing JSON: Invalid format or content in", path)
		return {}

func load_level():
	Global.song_end.connect(transition_to_score)
	Global.player_speed = 700
	Global.new_level(load(level_data["song_path"]), int(level_data["bpm"]))
	beat_distance = Global.player_speed * Global.sec_per_beat
	player.initialize_level()
	
	backgroud.region_rect.size.x = Global.player_speed * Global.song_duration + 1920
	floor.region_rect.size.x = Global.player_speed * Global.song_duration + 1920
	
	for b_data in level_data["beats"]:
		var new_beat: Beat = beat.instantiate()
		new_beat.initialise(b_data)
		add_child(new_beat)
		beats.append(new_beat)

func transition_to_score():
	GameManager.change_scene("level_select")

func show_hit_accuracy(value: float):
	accuracy_reader.value = 50 + value*500
