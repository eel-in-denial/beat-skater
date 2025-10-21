extends Panel

@onready var title := $VBoxContainer/Title
@onready var artist := $VBoxContainer/Artist
@onready var beatmapper := $VBoxContainer/Beatmapper
@onready var bpm := $VBoxContainer/BPM
@onready var init_player_speed := $"VBoxContainer/Player Initial Speed"
@onready var song := $VBoxContainer/Song
@onready var community_toggle := $CheckButton

var song_index := -1
var curr_song_data: Dictionary

signal save_song_data(idx: int, data: Dictionary)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


func pop_up(data := {
	"header_info": {
		"title": "",
		"artist": "",
		"beatmapper": "",
		"path": "",
		"editor_path": "",
		"song_idx": -1
	},
	"body_info": {
		"bpm": 0,
		"init_player_speed": 0.0
	},
	"community": false
}, idx: int = -1):
	visible = true
	curr_song_data = data
	song_index = idx
	set_values()
	
func close():
	visible = false
	get_tree().paused = false

func set_values():
	title.text = curr_song_data["header_info"]["title"]
	artist.text = curr_song_data["header_info"]["artist"]
	beatmapper.text = curr_song_data["header_info"]["beatmapper"]
	bpm.text = str(curr_song_data["body_info"]["bpm"])
	init_player_speed.text = str(curr_song_data["body_info"]["init_player_speed"])
	song.selected = curr_song_data["header_info"]["song_idx"]
	community_toggle.button_pressed = curr_song_data["community"]

func get_values():
	curr_song_data["header_info"]["title"] = title.text
	curr_song_data["header_info"]["artist"] = artist.text
	curr_song_data["header_info"]["beatmapper"] = beatmapper.text
	curr_song_data["body_info"]["bpm"] = int(bpm.text)
	curr_song_data["body_info"]["init_player_speed"] = float(init_player_speed.text)
	curr_song_data["header_info"]["song_idx"] = song.selected
	curr_song_data["community"] = community_toggle.button_pressed

func _on_cancel_pressed() -> void:
	close()

func _on_save_pressed() -> void:
	get_values()
	close()
	save_song_data.emit(song_index, curr_song_data)

func _on_delete_pressed() -> void:
	pass # Replace with function body.
