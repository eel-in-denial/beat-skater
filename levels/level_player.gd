extends Node2D

var background = preload("res://level_assets/scenes/background.tscn")
var beat = preload("res://level_assets/scenes/beat.tscn")
#var floor = preload("")
var beat_distance := 0.0
var player_position := 480.0

@onready var backgrouds: Array[Sprite2D] = [$Background]
@onready var player := $Player
var beats: Array[Beat] = []
var json_path = Global.level_path
var level_data: Dictionary


#var level_1_beats = [
#[1, 13, 1], [1, 13, 2.5], [11, 13, 4, 14, 2], [1, 14, 3], [2, 14, 3.5], [11, 14, 4.5, 16, 1],
#[2, 17, 1], [1, 17, 2.5], [22, 17, 4, 18, 3], [1, 19, 1], [2, 19, 2.5], [11, 19, 4, 20, 3], [2, 21, 1], [1, 21, 2.5], [22, 21, 4, 22, 2], [2, 22, 3], [1, 22, 3.5], [22, 22, 4.5, 24, 4],
#[1, 25, 1], [2, 25, 2.5], [11, 25, 4, 26, 2], [2, 26, 3], [1, 26, 3.5], [2, 26, 4], [1, 26, 4.5], [2, 27, 1], [1, 27, 2.5], [22, 27, 4, 28, 2], [1, 28, 2.5], [2, 28, 3.5], [1, 28, 4], [2, 28, 4.5]]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	Global.new_level(load(level_data["song_path"]), level_data["bpm"])
	beat_distance = Global.speed * Global.sec_per_beat
	player.initialize_level()
	
	for b in level_data["beats"]:
		var new_beat: Beat = beat.instantiate()
		var time_pos: float = Global.sec_per_beat * (b["beat"] - 1)
		if b["press_type"] == "hold":
			pass
		var hold_time := 0.0
		if b[0] == 11 or b[0] == 22:
			hold_time = Global.sec_per_beat * (((b[3] - 1) * 4 + b[4] - 1) - ((b[1] - 1) * 4 + b[2] - 1))
		new_beat.initialise(
			b["beat_type"], b["height"], time_pos, 
			Vector2(player_position + time_pos*Global.speed, 670), hold_time)
		add_child(new_beat)
		beats.append(new_beat)

func transition_to_score():
	get_tree().change_scene_to_file("res://test/title_screen.tscn")
