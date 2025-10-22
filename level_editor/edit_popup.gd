extends Panel

@onready var title := $VBoxContainer/Title
@onready var artist := $VBoxContainer/Artist
@onready var beatmapper := $VBoxContainer/Beatmapper
@onready var bpm := $VBoxContainer/HBoxContainer2/BPM
@onready var beats_per_bar := $VBoxContainer/HBoxContainer2/BeatsPerBar
@onready var init_player_speed := $"VBoxContainer/Player Initial Speed"
@onready var song := $VBoxContainer/Song
@onready var community_toggle := $CheckButton

var level_index := -1
var curr_song_data: Dictionary
var music_path: String
var songs_array: Array

signal save_song_data(idx: int, data: Dictionary)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


func pop_up(
	data := {
		"header": {
			"title": "",
			"artist": "",
			"beatmapper": "",
			"path": "",
			"editor_path": "",
			"song_path": ""
		},
		"body": {
			"bpm": 0,
			"beats_per_bar": 4,
			"init_player_speed": 0.0,
		},
		"community": false
	}, 
	idx: int = -1
):
	visible = true
	curr_song_data = data
	level_index = idx
	set_values()
	
func close():
	visible = false
	get_tree().paused = false

func set_values():
	title.text = curr_song_data["header"]["title"]
	artist.text = curr_song_data["header"]["artist"]
	beatmapper.text = curr_song_data["header"]["beatmapper"]
	bpm.text = str(curr_song_data["body"]["bpm"])
	beats_per_bar.text = str(curr_song_data["body"]["beats_per_bar"])
	init_player_speed.text = str(curr_song_data["body"]["init_player_speed"])
	community_toggle.button_pressed = curr_song_data["community"]
	music_path = "res://levels/music"
	songs_array = song.dir_contents(music_path)
	song.selected = songs_array.find(curr_song_data["header"]["song_path"])
	

func get_values():
	curr_song_data["header"]["title"] = title.text
	curr_song_data["header"]["artist"] = artist.text
	curr_song_data["header"]["beatmapper"] = beatmapper.text
	curr_song_data["body"]["bpm"] = int(bpm.text)
	curr_song_data["body"]["beats_per_bar"] = int(beats_per_bar.text)
	curr_song_data["body"]["init_player_speed"] = float(init_player_speed.text)
	curr_song_data["header"]["song_path"] = music_path + song.get_item_text(song.selected)
	curr_song_data["community_toggled"] = community_toggle.button_pressed

func _on_cancel_pressed() -> void:
	close()

func _on_save_pressed() -> void:
	get_values()
	close()
	save_song_data.emit(level_index, curr_song_data)


func _on_check_button_toggled(toggled_on: bool) -> void:
	curr_song_data["community"] = toggled_on
	if toggled_on:
		music_path = "user://levels/music"
		songs_array = song.dir_contents(music_path)
	else:
		music_path = "res://levels/music"
		songs_array = song.dir_contents(music_path)
