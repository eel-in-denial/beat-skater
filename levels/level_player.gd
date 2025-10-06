extends Node2D

var beat = preload("res://level_assets/beat/beat.tscn")
#var floor = preload("")
var beat_distance := 0.0


@onready var backgroud: Sprite2D = $Background
@onready var floor := $Floor
@onready var player := $Player
@onready var accuracy_reader := $CanvasLayer/ProgressBar
@onready var song_pos := $CanvasLayer/Label2
var beats: Array[Beat] = []
var json_path: String
var level_data: Dictionary


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
	Global.player_speed = 700
	Global.new_level(load(level_data["song_path"]), level_data["bpm"])
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
	$CanvasLayer/Label.text = str(value)
