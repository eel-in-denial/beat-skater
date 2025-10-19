extends Panel

@onready var title := $VBoxContainer/Title
@onready var artist := $VBoxContainer/Artist
@onready var beatmapper := $VBoxContainer/Beatmapper
@onready var bpm := $VBoxContainer/BPM
@onready var player_init_speed := $"VBoxContainer/Player Initial Speed"
@onready var song := $VBoxContainer/Song
@onready var community_toggle := $CheckButton

var song_index := -1
var curr_song_data: Dictionary

signal save_song_data(idx: int, data: Dictionary)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	set_values()


func pop_up(data := {
	"header_info": {
		"title": "",
		"artist": "",
		"beat_mapper": "",
		"path": "",
		"editor_path": ""
	},
	"body_info": {
		"bpm": "0",
		"init_player_speed": "0.0"
	},
	"community": false
}):
	visible = true
	curr_song_data = data
	
func close():
	visible = false
	get_tree().paused = false

func set_values():
	title.text = ""
	artist.text = ""
	beatmapper.text = ""
	bpm.text = "0"
	player_init_speed.text = "0.0"
	song.selected = -1
	community_toggle.button_pressed = false

func _on_cancel_pressed() -> void:
	close()

func _on_save_pressed() -> void:
	close()
	save_song_data.emit(song_index, curr_song_data)
