extends Node2D

var beat = preload("res://level_assets/beat/beat.tscn")

@onready var path := $LevelPath
@onready var player := $Player
#@onready var accuracy_reader := $CanvasLayer/ProgressBar
#@onready var song_pos := $CanvasLayer/Label2
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

#func _physics_process(delta: float) -> void:
	#song_pos.text = str(Global.beat_position)

func load_level():
	player_initial_speed = 700
	Global.new_level(load(level_data["song_path"]), level_data["bpm"])
	player.init()

func transition_to_score():
	GameManager.change_scene("level_select")
