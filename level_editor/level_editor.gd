@tool
extends Control

@export_tool_button("bake", "Bake") var bake = _on_bake_pressed
@export var level_json_path: String:
	set(value):
		level_json_path = value
		init_level()

@export_group("Song Details")
@export var title := ""
@export var artist := ""
@export var bpm := 100
@export var song: AudioStreamOggVorbis

@export_group("Player Presets")
@export var player_initial_speed := 0.0
@export var player_jump_height := 500
@export var player_screen_position := Vector2(480.0, 0)
@export var gravity := Vector2(0, 980)

@export_group("Editor Details")
@export var beat_snapping := 1.0

var beat_time_positions := []
var beats_array := []
var curve_points_array := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init_level():
	print("level_loading...")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_level():
	pass


func _on_bake_pressed() -> void:
	var level_save = {
		"title": title,
		"artist": artist,
		"bpm": bpm,
		"player_initial_speed": player_initial_speed,
		"song_path": level_json_path,
		"beats": beats_array,
		"curve_points": curve_points_array
	}
